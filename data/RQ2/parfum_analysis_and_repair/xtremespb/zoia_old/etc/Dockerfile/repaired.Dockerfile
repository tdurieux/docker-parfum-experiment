FROM node:slim
WORKDIR /usr/local/zoia
RUN apt-get update && apt-get install --no-install-recommends unzip -y && \
wget -q -O - https://xtremespb.github.io/zoia/zoia_install_min | bash && \
node ./bin/config.js -d && rm -rf /var/lib/apt/lists/*;
EXPOSE 3000
ENTRYPOINT ["node", "./bin/webserver"]