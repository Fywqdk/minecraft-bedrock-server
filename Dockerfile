FROM ubuntu:focal

ARG VER=latest

ENV VERSION=$VER

ENV LATEST_VERSION=""

ENV LD_LIBRARY_PATH=/bedrock-server/

RUN apt update && apt install -y curl unzip nano

### Install Script
RUN mkdir -p /bedrock-server/config /bedrock-server/worlds /bedrock-server/info \
    && if [ "$VERSION" = "latest" ]; then \
        echo "using latest version." \
    &&  export LATEST_VERSION=$(curl -v -L --silent \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
        https://terraria.fandom.com/wiki/Server#Downloads 2>&1 | grep -o 'https://terraria.org/api/download/pc-dedicated-server/[^"]*' \
        | sed 's#.*/terraria-server-##' | sed 's/.zip//' | tail -1) \
    &&  export VERSION=${LATEST_VERSION}; fi \
    && echo "VERSION=${VERSION}" \
    && echo "${VERSION}" > /bedrock-server/info/version.txt \
    && touch /bedrock-server/local-version.txt && echo "${VERSION}" > /bedrock-server/local-version.txt \
    
    && curl https://minecraft.azureedge.net/bin-linux/bedrock-server-${VERSION}.zip --output bedrock-server.zip \
    && unzip bedrock-server.zip -d bedrock-server && rm bedrock-server.zip \
    
    && mv -vn /bedrock-server/whitelist.json /bedrock-server/config/whitelist.json \
    && mv -vn /bedrock-server/permissions.json /bedrock-server/config/permissions.json \
    && mv -vn /bedrock-server/server.properties /bedrock-server/config/server.properties \
    
    && ln -s /bedrock-server/config/whitelist.json /bedrock-server/whitelist.json \
    && ln -s /bedrock-server/config/permissions.json /bedrock-server/permissions.json \
    && ln -s /bedrock-server/config/server.properties /bedrock-server/server.properties \
    
    && chmod +x /bedrock-server/start-server.sh \
    && chmod +x /bedrock-server/bedrock_server

EXPOSE 19132/udp

VOLUME ["/bedrock-server/worlds", "/bedrock-server/config", "/bedrock-server/info"]

COPY start-server.sh /bedrock-server/start-server.sh

WORKDIR /bedrock-server

CMD ["/bin/sh", "-c", "./start-server.sh"]

