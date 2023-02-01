FROM nodered/node-red:latest-12

USER root

RUN apk update && apk add --no-cache py3-setuptools ffmpeg
RUN curl -f -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
RUN chmod a+rx /usr/local/bin/youtube-dl
RUN youtube-dl --version
USER node-red

