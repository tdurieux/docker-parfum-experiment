FROM node:16

RUN apt update && apt install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;

RUN cd ~/
COPY config.json ./

RUN npm -g config set user root
RUN npm install -g gtfs-to-html && npm cache clean --force;

CMD [ "gtfs-to-html" ]