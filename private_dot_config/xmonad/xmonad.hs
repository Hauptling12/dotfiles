--{{{imports
-- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import qualified XMonad.StackSet as W
-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
--import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll) -- killAll
import qualified XMonad.Actions.Search as S
-- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M
-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ThreeColumns
--import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
-- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
--}}}
--{{{colors
colorBack = "#282c34"
colorFore = "#bbc2cf"
color02 = "#ff6c6b"
color06 = "#c678dd"
color08 = "#202328"
color09 = "#5b6268"
color12 = "#ecbe7b"
color15 = "#46d9ff"
color16 = "#dfdfdf"
color17 = "#FF5F1F"
color18 = "#778899"
colorTrayer :: String
colorTrayer = "--tint 0x282c34"
--}}}
--{{{vars
myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"
-- xft:Hack Nerd Font Mono:size=

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "st"    -- Sets default terminal

myBrowser :: String
myBrowser = "librewolf"

myEditor :: String
myEditor = myTerminal ++ " -e nvim " -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2      -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color18
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
--}}}
--{{{ startup
myStartupHook :: X ()
myStartupHook = do
--    spawn "killall trayer"  -- kill current trayer on each restart
--    spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 22")
    spawn ("xautolock -time 60 -locker slock")
    spawn "killall trayer"
    spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 22")
    spawnOnce "feh --bg-scale $HOME/halo.jpeg --no-fehbg"
--}}}
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg


spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 3 -- changed check if works less gaps
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mpv" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                , NS "pulsemixer" spawnPulse findPulse managePulse
                , NS "wiki" spawnWiki findWiki manageWiki
                , NS "file" spawnFile findFile manageFile
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnPulse= myTerminal ++ " -t scratchpad"
    findPulse= title =? "scratchpad"
    managePulse= customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnFile= myTerminal ++ " -t scratchpad"
    findFile= title =? "scratchpad"
    manageFile= customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnWiki= myTerminal ++ " -t scratchpad"
    findWiki= title =? "scratchpad"
    manageWiki= customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t music"
    findMocp   = title =? "music-sc"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = myTerminal ++ " -t calc"
    findCalc   = title =? "calc"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w


--{{{layouts
-- limitWindows sets maximum number of windows displayed
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
tabs     = renamed [Replace "tabs"]
           $ tabbed shrinkText myTabTheme

-- setting colors for tabs layout and tabs sublayout
myTabTheme = def { fontName            = myFont
                 , activeColor         = color18
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }
-- Theme for showWName which prints current workspace when you change workspace
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| ThreeCol 1 (3/100) (1/2)
                                 ||| Mirror (Tall 1 (3/100) (3/5))

--}}}
myExtraWorkspaces = [(xK_0, "10"),(xK_minus, "11"),(xK_equal, "12"),(xK_grave, "13"),(xK_bracketright, "14"),(xK_bracketleft, "15"),(xK_backslash, "16"),(xK_semicolon, "17"),(xK_apostrophe, "18")]

myWorkspaces = [" 1d ", " 2ju ", " 3com ", " 4doc ", " 5vm ", " 6www ", " 7mus ", " 8st ", " 9vim " ] ++ (map snd myExtraWorkspaces)
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8
     [ className =? "error"           --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 2 )
    -- , className =?  --> doShift  ( myWorkspaces !! 4 )
     , className =? "pm" --> doShift  ( myWorkspaces !! 2 )
     , className =? "Signal" --> doShift  ( myWorkspaces !! 5 )
     , isFullscreen -->  doFullFloat
     ]

--{{{START_KEYS
myKeys :: [(String, X ())]
myKeys =
    -- KB_G Xmonad
        [ ("M-S-r", spawn "xmonad --recompile ")       -- Recompiles xmonad ands Restarts xmonad
        , ("M-C-r", spawn "xmonad --restart")       -- Recompiles xmonad ands Restarts xmonad
    -- KB_G Run Prompt
        , ("M-r", spawn "dmenu_run")
        , ("M-w", spawn (myTerminal ++ " -e win-switch"))
-- KB_G dmenu scripts
        , ("M-S-d m", spawn "dmenumount")
        --, ("M-S-d s", spawn "~/./scripts/bash/dmenu/scripts/webhttp")
        , ("M-S-d e", spawn "dmenuunicode")
        , ("M-S-d w", spawn "networkmanager_dmenu")
        , ("M-S-d r", spawn (myTerminal ++ " -e dmenurecord"))
        , ("M-S-d l", spawn (myTerminal ++ " -e fzf-buku"))
        , ("M-S-d b", spawn "dmweb")
        , ("M-S-d a", spawn "arch-wiki.sh")
        , ("M-S-d s", spawn "maimpick")
        , ("M-S-d u", spawn "dmenuunmount")
        , ("M-S-d S-m", spawn "dmenu-mpv")

    -- KB_G prgograms
         , ("M-x", spawn myTerminal)
         , ("M-b", spawn myBrowser)
         , ("M-s", spawn (myTerminal ++ " -e htop"))
         , ("M-a", spawn (myTerminal ++ " -e calcurse"))
         , ("M-S-a", spawn "tmux new-window -t 0:0 'calcurse'")
	 , ("M-S-c", spawn (myTerminal ++ " -e calc"))
         , ("M-i n", spawn (myTerminal ++ " -e newsboat -r"))
         , ("M-i S-n", spawn "tmux new-window -t 0:0 'newsboat -r'")
	 , ("M-i t", spawn (myTerminal ++ " -e /bin/nmtui"))
         , ("M-c", spawn myEditor)
         , ("M-S-v", spawn (myTerminal ++ " -e pulsemixer"))
         , ("M-S-x", spawn (myTerminal ++ " -e tmux"))
         , ("M-n", spawn (myTerminal ++ " -e vifm"))
         , ("M-e h", spawn "xmonad_keys.sh") -- shows list of keybindings
         , ("M-M1-t", spawn "qbittorrent")
         , ("M-i b", spawn (myTerminal ++ " -e bluetoothctl"))
         , ("M-y", spawn "xmouseless")
         , ("M-S-g", spawn "signal-desktop-no-yes")
         , ("M-S-b", spawn "librewolf --private-window")
         , ("M-v", spawn "virt-manager")
         , ("M-S-l", spawn "slock")
         , ("M-e k", spawn "keepassxc")
    -- KB_G Kill windows
         , ("M-S-q", kill1)     -- Kill the currently focused client

    -- KB_G Workspaces

    -- KB_G Floating windows
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile
    -- KB_G brightness control
    -- KB_G Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master wind
        , ("M-<Tab>", windows W.focusUp)      -- Move focus to the prev wind
        , ("M-S-<Tab>", windows W.focusDown)      -- Move focus to the prev window
        , ("M-M1-m", windows W.swapMaster) -- Swap the focused window and the master wind
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next wind
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev wind
        , ("M-<Backspace>", promote)      -- Moves focused wind to master, others maintain order
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the winds in the current stack

    -- KB_G Layouts
        , ("M-<Space>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- KB_G Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-j", increaseLimit)                   -- Increase # of windows
        , ("M-C-k", decreaseLimit)                 -- Decrease # of windows

    -- KB_G Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- KB_GROUP Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("M-S-s t", namedScratchpadAction myScratchPads "terminal")
        , ("M-S-s m", namedScratchpadAction myScratchPads "mocp")
        , ("M-S-s c", namedScratchpadAction myScratchPads "calculator")
        , ("M-S-s v", namedScratchpadAction myScratchPads "pulsemixer")
        , ("M-S-s w", namedScratchpadAction myScratchPads "wiki")
        , ("M-S-s e", namedScratchpadAction myScratchPads "file")

    -- KB_G Sublayouts
    -- This is used to push windows to tabbed sublayouts or pull them out of it
        , ("M-M1-h", sendMessage $ pullGroup L)
        , ("M-M1-l", sendMessage $ pullGroup R)
        , ("M-M1-k", sendMessage $ pullGroup U)
        , ("M-M1-j", sendMessage $ pullGroup D)
        , ("M-M1-m", withFocused (sendMessage . MergeAll))
        -- , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab
-- KB_G monitors
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
    -- KB_G Multimedia Keys
        , ("<F1>", spawn "amixer set Master toggle")
        , ("M-<F2>", spawn "amixer set Master 6%- unmute")
        , ("M-<F3>", spawn "amixer set Master 6%+ unmute")
        , ("<F2>", spawn "amixer set Master 3%- unmute")
        , ("<F3>", spawn "amixer set Master 3%+ unmute")
        , ("M-S-'", windows $ W.shift "18")
        , ("M-'", windows $ W.greedyView "18")
        , ("M-S-;", windows $ W.shift "17")
        , ("M-;", windows $ W.greedyView "17")
        , ("M-S-\\", windows $ W.shift "16")
        , ("M-\\", windows $ W.greedyView "16")
        , ("M-S-[", windows $ W.shift "15")
        , ("M-[", windows $ W.greedyView "15")
        , ("M-S-]", windows $ W.shift "14")
        , ("M-]", windows $ W.greedyView "14")
        , ("M-S--", windows $ W.shift "11")
        , ("M--", windows $ W.greedyView "11")
        , ("M-S-=", windows $ W.shift "12")
        , ("M-=", windows $ W.greedyView "12")
        , ("M-S-0", windows $ W.shift "10")
        , ("M-0", windows $ W.greedyView "10")
        , ("M-S-`", windows $ W.shift "13")
        , ("M-`", windows $ W.greedyView "13")
        ]
          -- The following lines are needed for named scratchpads.
    where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
--}}}END_KEYS
--{{{main
main :: IO ()
main = do
-- Launching xmobar
    xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobar/xmobarrc")
    xmproc1 <- spawnPipe ("xmobar -x 1 $HOME/.config/xmobar/xmobarrc")
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
        , focusFollowsMouse  = False
                               -- Uncomment this line to enable fullscreen support on youtube etc
 --        <+> fullscreenEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP  $ xmobarPP
              -- XMOBAR SETTINGS
              { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                              >>  hPutStrLn xmproc1 x
                -- Current workspace
             ,  ppCurrent = xmobarColor color12 "" . wrap
                            ("<box type=Bottom width=2 mb=2 color=" ++ color12 ++ ">") "</box>"
                -- Visible but not current workspace
              , ppVisible = xmobarColor color06 ""
                -- Hidden workspace
              , ppHidden = xmobarColor color17 "" . wrap
                           ("<box type=Top width=2 mt=2 color=" ++ color17 ++ ">") "</box>"
                -- Hidden workspaces (no windows)
              , ppHiddenNoWindows = xmobarColor color16 ""
                -- Title of active window
              , ppTitle = xmobarColor color16 "" . shorten 50
                -- Separator character
              , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
                -- Urgent workspace
              , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
                -- Adding # of windows on current workspace to the bar
              , ppExtras  = [windowCount]
                -- order of things in xmobar
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
              }
        } `additionalKeysP` myKeys
--}}}
