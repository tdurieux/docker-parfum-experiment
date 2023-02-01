FROM node:14-slim AS builder
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ make python && rm -rf /var/lib/apt/lists/*;
# Bundle APP files
COPY . .
# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install --production && npm cache clean --force;
# Show current folder structure in logs
RUN ls -al -R


FROM node:14-slim AS executor
WORKDIR /root
RUN npm install pm2 -g && npm cache clean --force;
COPY --from=builder /root ./

EXPOSE 3000
CMD [ "pm2-runtime", "start", "pm2.json" ]
