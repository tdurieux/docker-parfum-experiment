FROM node:8

RUN apt-get update && apt-get install --no-install-recommends -y chromium xvfb && rm -rf /var/lib/apt/lists/*;
RUN npm install jspm gulp -g && npm cache clean --force;

ADD build_client_cmd.sh /
ADD watch_client_cmd.sh /

