FROM node:10
RUN apt update && apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
	&& chmod a+rx /usr/local/bin/youtube-dl
WORKDIR /cyp
COPY package.json .
RUN npm i && npm cache clean --force;
COPY index.js .
COPY app ./app
EXPOSE 8080
ENTRYPOINT ["node", "."]
