FROM shareai/tensorflow:nano_latest


# Install package dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y pkg-config graphicsmagick curl sqlite3 libsqlite3-dev libcairo2-dev libgif-dev && \
    curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update && apt-get install --no-install-recommends -y nodejs libdrm-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD --chown=root:root https://repo.download.nvidia.com/jetson/jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
RUN chmod 644 /etc/apt/trusted.gpg.d/jetson-ota-public.asc \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://repo.download.nvidia.com/jetson/ffmpeg main main" | tee -a /etc/apt/sources.list && \
    echo "deb-src https://repo.download.nvidia.com/jetson/ffmpeg main main" | tee -a /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/
COPY ./nvr_releases/2018.03.15.14.50.tar.gz /opt/2018.03.15.14.50.tar.gz

RUN mkdir -p /opt/nvr && tar -zxf 2018.03.15.14.50.tar.gz && mv Shinobi-2018.03.15.14.50/* /opt/nvr/ && \
    rm -rf /opt/Shinobi-2018.03.15.14.50/ && cd /opt/nvr && \
    # Install NodeJS dependencies
    npm install && \
    npm install canvas@1.6 moment ffmpeg-static --unsafe-perm && \
    rm /root/.npm/* -rf && \
    rm -rf Shinobi-Shinobi-2018.03.15.14.50 && npm cache clean --force; && rm 2018.03.15.14.50.tar.gz

ADD nvr_releases/2018.03.15.14.50_patchs/* /opt/nvr/

ADD docker-entrypoint.sh /opt/nvr/docker-entrypoint.sh
ADD conf.d/main.conf.json /opt/nvr/conf.json
ADD conf.d/super.json /opt/nvr/super.json

RUN cd /root && \
    git clone https://github.com/SharpAI/DeepCamera && \
    mv /root/DeepCamera/src/detector  /opt/nvr/detector && \
    rm -rf /root/DeepCamera

WORKDIR /opt/nvr/detector
RUN npm install && npm run build && cp dist/release/* . -a && cp dist/release/libs/* ./libs/ -a && rm -rf dist && rm -rf uglifyjs-es-cmd \
    rm /opt/2018.03.15.14.50.tar.gz && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /root/.npm/* -rf && npm cache clean --force;

WORKDIR /opt/nvr
COPY sql/conf.sqlite sql/shinobi.sample.sqlite
RUN cp sql/shinobi.sample.sqlite /opt/nvr/conf.sqlite
RUN cp /usr/bin/ffmpeg /opt/nvr/node_modules/ffmpeg-static/bin/linux/arm64/ffmpeg
VOLUME ["/opt/nvr/videos"]

EXPOSE 8080
ENTRYPOINT ["/opt/nvr/docker-entrypoint.sh" ]
