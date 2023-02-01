FROM ubuntu:20.04

LABEL maintainer="shukri.adams@gmail.com" \
    src="https://github.com/shukriadams/arewedown"

RUN apt-get update \
    && apt-get install --no-install-recommends bash -y \
    && apt-get install --no-install-recommends sudo -y \
    && apt-get install --no-install-recommends git -y \
    && apt-get install --no-install-recommends curl -y \
    && apt-get install --no-install-recommends sshpass -y \
    && apt-get install --no-install-recommends python3-minimal -y \
    && apt-get install --no-install-recommends python3-pip -y \
    && curl -f -s -O https://deb.nodesource.com/node_12.x/pool/main/n/nodejs/nodejs_12.20.2-deb-1nodesource1_amd64.deb \
    && dpkg -i nodejs_12.20.2-deb-1nodesource1_amd64.deb \
    && rm nodejs_12.20.2-deb-1nodesource1_amd64.deb \
    && mkdir -p /etc/arewedown \
    && adduser -u 1000 arewedown \
    && adduser arewedown sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && chmod 700 -R /etc/arewedown \
    && chown -R arewedown /etc/arewedown && rm -rf /var/lib/apt/lists/*;

COPY ./.stage/src/. /etc/arewedown

USER arewedown

CMD cd /etc/arewedown && npm start