#!/bin/bash
#
### BEGIN INFO
#
# Name:              get-mediawiki.sh
# Author:            Patrick Gunzelmann <patrick@gunzelmann.com>
# Short-Description: Get the latest release of a specific or the latest mediawiki Major version
# Description:       This script may be used to download the latest version of a mediawiki
#                    major version given to it while executing it. The script will automatically
#                    search for the latest release of the given major version or the latest
#                    release of the latest stable major version if you use "latest" as major
#                    version identifier.
#
###


# Parse input and find the right major version to download
if [ "$1" == "latest" ]
then
    AVAILABLE_MAJORS=( $(curl -s https://releases.wikimedia.org/mediawiki/ | \
                       grep "<a href=" | grep -o '[0-9]\.[0-9]*' | uniq) )
    if [ $(curl -s https://releases.wikimedia.org/mediawiki/${AVAILABLE_MAJORS[0]}/ | \
           grep 'mediawiki-[0-9]\.[0-9]*' | awk -F '[<>]' '{print $5}' | \
           grep '\.tar\.gz$' | grep -v -c 'rc') -eq 0 ]
    then
        MAJOR=${AVAILABLE_MAJORS[1]}
    else
        MAJOR=${AVAILABLE_MAJORS[0]}
    fi
elif [ "$1" == "LTS" ]
then
    MAJOR=$(curl -fsSL https://www.mediawiki.org/wiki/Download | grep LTS | grep -m1 -o "[1-9]\.[0-9][0-9]*" | uniq)
elif expr "$1" : '^1\.[1-9][0-9]*$' >/dev/null
then
    MAJOR=$1    
else
    echo "ERROR: Unexpected version string!"
    echo "Please use script as follows:"
    echo $1 " <MediaWiki Major Version>"
    exit 1
fi


# Search for the latest stable release for the major version
FILE=$(curl -s https://releases.wikimedia.org/mediawiki/$MAJOR/ | \
       grep 'mediawiki-[0-9]\.[0-9]*' | awk -F '[<>]' '{print $5}' | \
       grep '\.tar\.gz$' | grep -v -m1 'rc')


# Check if we found a stable release for the given major version
if [ "$FILE" == "" ]
then
    echo "ERROR: Invalid Major version"
    echo "Major Version is not available yet or no stable release found for this major version"
    exit 1
fi


# Download the mediawiki release and its signature to /tmp/
curl -fSLs "https://releases.wikimedia.org/mediawiki/$MAJOR/$FILE" -o /tmp/mediawiki.tar.gz
curl -fSLs "https://releases.wikimedia.org/mediawiki/$MAJOR/$FILE.sig" -o /tmp/mediawiki.tar.gz.sig
