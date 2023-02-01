FROM node:0.11-slim
RUN apt-get update && apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/prawnsalad/KiwiIRC.git /kiwi
RUN ( cd /kiwi && npm install && cp config.example.js config.js) && npm cache clean --force;
RUN (cd /kiwi && ./kiwi build)
WORKDIR /kiwi
EXPOSE 7778
CMD ["./kiwi", "-f", "start"]
