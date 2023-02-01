FROM node:12-slim

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN npm i -g ghost-static-site-generator live-server && npm cache clean --force;

ENTRYPOINT ["gssg"]

WORKDIR /app
COPY run.sh .

ENTRYPOINT ["./run.sh"]
