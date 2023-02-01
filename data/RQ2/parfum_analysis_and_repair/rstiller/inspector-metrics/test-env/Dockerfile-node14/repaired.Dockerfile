FROM node:14

RUN apt-get update && apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN npm i -g pnpm@6.15.2 && npm cache clean --force;
