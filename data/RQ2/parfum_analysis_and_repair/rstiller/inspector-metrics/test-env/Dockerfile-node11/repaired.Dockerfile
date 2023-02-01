FROM node:11

RUN apt-get update && apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN npm i -g pnpm@4.14.4 && npm cache clean --force;
