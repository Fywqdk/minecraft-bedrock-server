#!/bin/bash
# First Argument is the output location. Defaults to current directory

echo 'Downloading latest version'

[[ -z ${1} ]] && dest=. || dest=${1%/}

# Hard coded latest version
LATEST_VERSION="1.20.71.01"

echo "Latest version is " ${LATEST_VERSION}
echo "Collection and unzipping"
#LATEST_VERSION=$(curl -L --silent -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
#    https://www.minecraft.net/en-us/download/server/bedrock/ 2>&1 \
#    | grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' \
#    | sed 's#.*/bedrock-server-##' \
#    | sed 's/\.zip//')
curl -L --silent -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://minecraft.azureedge.net/bin-linux/bedrock-server-${LATEST_VERSION}.zip --output ${dest}/bedrock-server.zip \
    && unzip -qq -o ${dest}/bedrock-server.zip -d ${dest} \
    && rm ${dest}/bedrock-server.zip
echo "Done - Hopefully without errors"
