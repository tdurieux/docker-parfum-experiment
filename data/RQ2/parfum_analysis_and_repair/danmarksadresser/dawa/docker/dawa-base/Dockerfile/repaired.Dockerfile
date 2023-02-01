FROM node:lts
RUN apt-get update && apt-get install --no-install-recommends -y p7zip-full && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . .
RUN yarn install && yarn cache clean;
