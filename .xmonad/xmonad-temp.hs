-- imports
  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
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
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName


    -- Layouts
--import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
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
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

   -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.DoomOne

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "st"    -- Sets default terminal

myBrowser :: String
myBrowser = "brave "  -- Sets qutebrowser as browser

myMediapl :: String
myMediapl = "smplayer "  -- Sets music player has smplayer

myFilemgui :: String
myFilemgui = "pcmanfm "  -- Sets gui filemanger as pcmanfm

myFilemcli :: String
myFilemcli = myTerminal ++ " -e vifm"  -- Sets cli filemanger as vifm

myMcliplay :: String
myMcliplay = "playerctl"  -- Sets cli musicplay / controler as 

myScripts :: String
myScripts = "$HOME/scripts/bash "  -- Sets qutebrowser as browser

myMusiced :: String
myMusiced = "deadbeef "  -- Sets qutebrowser as browser

myEditor :: String
myEditor = "code "  -- Sets emacs as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 3           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


myStartupHook :: X ()
myStartupHook = do
    spawn "killall trayer"  -- kill current trayer on each restart
--    spawnOnce "feh --bg-scale $HOME/documents/photogrphy/wallpaper/DarkCyan.png"
   -- spawnOnce "lxsession"
   -- spawnOnce "picom"
    spawnOnce "~/./scripts/bash/xmonad/autostart"
    spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 16")

--    spawnOnce "xargs xwallpaper --stretch < ~/scripts/xmonad-wall"
    setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg



-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 3 -- changed check if works less gaps
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

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



-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ ResizableTall 1 (3/100) (1/2) []
-- magnify  = renamed [Replace "magnify"]
   --        $ smartBorders
     --      $ windowNavigation
     --      $ addTabs shrinkText myTabTheme
     --      $ subLayout [] (smartBorders Simplest)
    --     $ magnifier
    --       $ limitWindows 12
     --      $ mySpacing 8
     --      $ ResizableTall 1 (3/100) (1/2) []
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
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ spiral (6/7)
--threeCol = renamed [Replace "threeCol"]
--           $ smartBorders
--           $ windowNavigation
--           $ addTabs shrinkText myTabTheme
--          $ subLayout [] (smartBorders Simplest)
--           $ limitWindows 7
 --          $ ThreeCol 1 (3/100) (1/2)
--threeRow = renamed [Replace "threeRow"]
    --       $ smartBorders
    --       $ windowNavigation
    --       $ addTabs shrinkText myTabTheme
    --       $ subLayout [] (smartBorders Simplest)
    --       $ limitWindows 7
    --       -- Mirror takes a layout and rotates it by 90 degrees.
    --       -- So we are applying Mirror to the ThreeCol layout.
     --      $ Mirror
    --       $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
-- tallAccordion  = renamed [Replace "tallAccordion"]
   --        $ Accordion
-- wideAccordion  = renamed [Replace "wideAccordion"]
--           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
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
                 --                ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
  --                               ||| threeCol
                                 ||| spirals
--                                 ||| threeRow
                   --              ||| tallAccordion
                     --            ||| wideAccordion

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" 1ju ", " 2ju ", " 3s ", " 4doc ", " 5vm ", " 6so ", " 7mus ", " 8st ", " 9dev "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)


clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have
  --   , className =? "Brave-browser"   --> doShift 
 --    , className =? "mpv"             --> --doShift ( myWorkspaces !! 7 )
    -- , className =? "deadbeaf"        --> 
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "Yad"             --> doCenterFloat
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 2 )
     , className =? "Virtual Machine Manager" --> doShift  ( myWorkspaces !! 5 )
     , isFullscreen -->  doFullFloat
     ]

-- START_KEYS
myKeys :: [(String, X ())]
myKeys =
    -- KB_G Xmonad
        [ ("M-C-r", spawn "xmonad --recompile ")       -- Recompiles xmonad ands Restarts xmonad
        , ("M-C-r", spawn "xmonad --restart")       -- Recompiles xmonad ands Restarts xmonad

    -- KB_G Run Prompt
        , ("M-r", spawn "j4-dmenu-desktop")
        , ("M-d", spawn "dmenu_run")
        , ("M-w", spawn "~/scripts/bash/xmonad/rofi.sh")
-- KB_G dmenu scripts
        , ("M-C-S-l", spawn "~/./scripts/bash/dmenu/dm-logout.sh")
        , ("M-S-d d", spawn "~/./scripts/bash/dmenu/blue-wifi-dm.sh")
        , ("M-S-d s", spawn "~/./scripts/bash/dmenu/scripts/webhttp")
        , ("M-S-d m", spawn "~/./scripts/bash/dmenu/dm-man")
        , ("M-S-d w", spawn "~/./scripts/bash/dmenu/dm-wifi")
        , ("M-S-d c", spawn "~/./scripts/bash/dmenu/dm-confedit")
        , ("M-S-d k", spawn "~/./scripts/bash/dmenu/dm-kill")
        , ("M-S-d b", spawn "~/./scripts/bash/dmenu/dm-websearch")
        , ("M-S-d a", spawn "~/./scripts/bash/dmenu/arch-wiki.sh")
       -- , ("M-S-d ", spawn "~/./scripts/bash/dmenu/")

-- KB_G vscode workspaces
        , ("M-C-v e", spawn "~/./scripts/bash/vscode/eng")
        , ("M-C-v h", spawn "~/./scripts/bash/vscode/hist")
        , ("M-C-v  s", spawn "~/./scripts/bash/vscode/scie")
        , ("M-C-v b", spawn "~/./scripts/bash/vscode/scripts")
       -- , ("M-C-v ", spawn "~/./scripts/bash/vscode/")


    -- KB_G prgograms
         , ("M-x", spawn myTerminal)
         , ("M-b", spawn myBrowser)
         , ("M-s", spawn (myTerminal ++ " -e htop"))
         , ("M-C-p", spawn (myTerminal ++ " -e pwsh"))
         , ("M-M1-b", spawn (myTerminal ++ " -e bash"))
         , ("M-c", spawn myEditor)
         , ("M-S-m", spawn myMusiced)
         , ("M-S-x", spawn (myTerminal ++ " -e tmux"))
         , ("M-n", spawn myFilemcli)
         , ("M-S-n", spawn myFilemgui)
         , ("M-z", spawn "zeal")
         , ("M-S-h b", spawn "~/./scripts/bash/xmonad/bookmarks")
         , ("M-S-h h", spawn "~/./.xmonad/xmonad_keys.sh") -- shows list of keybindings
         , ("M-S-h a", spawn "~/./scripts/bash/xmonad/b_alias")
         , ("M-S-h p", spawn "~/./scripts/bash/xmonad/b_packages")
         , ("M-S-h d", spawn "~/./.xmonad/dup-keys.sh") -- shows list of dupiclite keys
         , ("M-l", spawn "libreoffice")
         , ("M-k", spawn "krita")
         , ("M-<Esc>", spawn "~/./scripts/bash/xmonad/kill-ne-app")
         , ("M-C-b", spawn "timeshift-gtk")
         , ("M-C-g", spawn "gimp")
    --     , ("M-S-v", spawn "") -- volume slides
         , ("M-C-d", spawn "drawio")
         , ("M-C-M1-a", spawn "android-studio")
         , ("M-M1-a s", spawn "arandr")
         , ("M-M1-a d", spawn "brave https://discord.com/channels/@me")
         , ("M-M1-c", spawn "blueberry")
         , ("M-S-M1-g", spawn "~/./scripts/bash/dmenu/signal-desktop-no-yes")
         , ("M-S-i", spawn (myTerminal ++ " -e vim ~/.xmonad/xmonad.hs"))
         , ("M-C-M1-p", spawn "~/./scripts/bash/xmonad/window-scre.sh")
         , ("M-S-b", spawn "brave --incognito")
         , ("M-j", spawn "flatpak run net.cozic.joplin_desktop")
         , ("M-h", spawn "planmaker21free")
         , ("M-o", spawn "obs")
         , ("M-a", spawn "audacium")
         , ("M-S-c", spawn "~/./my-work/appimages/uno-calculator-1.2.4-uno.725-x86_64.AppImage")
         , ("M-v", spawn "virt-manager")
         , ("M-g", spawn "github-desktop")

    -- KB_G Kill windows
         , ("M-S-q", kill1)     -- Kill the currently focused client
        -- , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- KB_G Workspaces
     --   , ("M-C-<Left>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
     --   , ("M-C-<Right>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- KB_G Floating windows
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile
        , ("M-S-z", spawn "~/./scripts/bash/xmonad/touchp-toggle.sh")

    -- KB_G Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master wind
        , ("M-S-<Tab>", windows W.focusUp)      -- Move focus to the prev wind
        , ("M-M1-m", windows W.swapMaster) -- Swap the focused window and the master wind
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next wind
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev wind
        , ("M-<Backspace>", promote)      -- Moves focused wind to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all winds except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the winds in the current stack

    -- KB_G Layouts
        , ("M-<Space>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- KB_G Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- KB_G Window resizing
        , ("M-<Left>", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-<Right>", sendMessage Expand)                   -- Expand horiz window width
       -- , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- KB_G Sublayouts
    -- This is used to push windows to tabbed sublayouts or pull them out of it
        , ("M-C-h", sendMessage $ pullGroup L)
        , ("M-C-l", sendMessage $ pullGroup R)
        , ("M-C-k", sendMessage $ pullGroup U)
        , ("M-C-j", sendMessage $ pullGroup D)
        , ("M-C-m", withFocused (sendMessage . MergeAll))
        -- , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- KB_G Multimedia Keys
       -- , ("<XF86AudioPlay>", spawn "mocp --play")
        --, ("<XF86AudioPrev>", spawn "mocp --previous")
      --  , ("<XF86AudioNext>", spawn "mocp --next")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
    --    , ("<Print>", spawn "")
        ]

    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
-- END_KEYS
-- `removeKeys`
--    [ (mod4Mask .|. shiftMask, xK_q)
--    , (mod4Mask .|. shiftMask, xK_w)
--    ]
main :: IO ()
main = do
-- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobar/xmobarrc")
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
        , focusFollowsMouse  = False
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
 --        <+> fullscreenEventHook

        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- XMOBAR SETTINGS
              { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                -- Current workspace
              , ppCurrent = xmobarColor color06 "" . wrap
                            ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
                -- Visible but not current workspace
              , ppVisible = xmobarColor color06 "" . clickable
                -- Hidden workspace
              , ppHidden = xmobarColor color05 "" . wrap
                           ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
                -- Hidden workspaces (no windows)
              , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
                -- Title of active window
              , ppTitle = xmobarColor color16 "" . shorten 60
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
