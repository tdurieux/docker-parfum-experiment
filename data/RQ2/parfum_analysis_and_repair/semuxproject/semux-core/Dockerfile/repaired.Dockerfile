FROM openjdk:8-jre

WORKDIR /

RUN apt-get update && apt-get install --no-install-recommends --yes curl jq && rm -rf /var/lib/apt/lists/*;

RUN LATEST=$( curl -f -s https://api.github.com/repos/semuxproject/semux-core/releases/latest | jq '.assets[]  | select(.name | contains("linux"))') && \
    LINK=`echo ${LATEST} | jq -r '.browser_download_url'` && \
    TARBALL=`echo ${LATEST} | jq -r '.name'` && \
    curl -f -Lo ${TARBALL} ${LINK} && \
    mkdir -p /semux && \
    tar -xzf ${TARBALL} -C /semux --strip-components=1 && \
    rm ${TARBALL}

RUN apt-get remove --yes curl jq

EXPOSE 5161

ENTRYPOINT ["/semux/semux-cli.sh"]
