ARG version
FROM sitespeedio/sitespeed.io:${version}

ENV SITESPEED_IO_BROWSERTIME__XVFB true
ENV SITESPEED_IO_BROWSERTIME__DOCKER true

RUN sudo apt-get update && sudo apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /webpagetest
RUN git clone https://github.com/sitespeedio/plugin-webpagetest.git .
RUN npm install --production && npm cache clean --force;

VOLUME /sitespeed.io
WORKDIR /sitespeed.io
