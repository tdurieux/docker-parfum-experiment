FROM debian:stable
MAINTAINER Vasyl Zakharchenko <vaszakharchenko@gmail.com>
LABEL author="Vasyl Zakharchenko"
LABEL email="vaszakharchenko@gmail.com"
LABEL name="rtsp-samsung-tv"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y gnupg2 ca-certificates lsb-release wget && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates --fresh
RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN apt-key add pubkey.gpg
RUN apt-get purge curl
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN wget -qO-  https://deb.nodesource.com/setup_14.x | bash
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg yarn nodejs curl && rm -rf /var/lib/apt/lists/*;
RUN npm i pm2 -g && npm cache clean --force;
# Bundle APP files
RUN npm i rtsp-samsung-tv@1.1.22 -g && npm cache clean --force;
# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
COPY entrypoint.sh /opt/entrypoint.sh
RUN  chmod +x /opt/entrypoint.sh
EXPOSE 3004
EXPOSE 9999
EXPOSE 10000
EXPOSE 10001
EXPOSE 10002
EXPOSE 10003
EXPOSE 10004

ENTRYPOINT ["/opt/entrypoint.sh"]
#CMD [ "pm2-runtime", "start", "pm2.json" ]
