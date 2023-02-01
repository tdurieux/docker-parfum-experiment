FROM node:6.11
MAINTAINER Brian Douglass

RUN apt-get install --no-install-recommends -y libstdc++6 && rm -rf /var/lib/apt/lists/*;
RUN npm install supervisor gulp -g && npm cache clean --force;

ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 8080
CMD run
