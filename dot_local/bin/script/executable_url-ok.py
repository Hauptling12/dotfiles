#!/bin/python3
import sys
import requests
from http.client import responses
import validators

if len(sys.argv) < 2:
    print('You need to specify at least url')
    sys.exit()

def usage():
    print("\nUsage:\nSingle URL: urlcheck <url>\nMultiple\
    URL's: urlcheck <url1> <url2> ... <urln>\n")

if sys.argv[1]=="help":
    usage()
    sys.exit()

def main():
    n = len(sys.argv)
    print("\n")
    for i in range(1, n):
        url = sys.argv[i]
        if validators.url(url) is True:
            status = requests.head(url).status_code
            try:
                print(url, status,responses[status], "\n")
            except:
                print(url, status, "Not an Standard HTTP Response code\n")
        else:
            print(url, "Not an valid URL\n")
            continue

if __name__ == "__main__":
    main()
