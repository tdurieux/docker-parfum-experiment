FROM node:16-bullseye

RUN apt update && apt install --no-install-recommends -y python2 && rm -rf /var/lib/apt/lists/*;
RUN npm config set python python2
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

ENV NEXT_TELEMETRY_DISABLED 1
ENV CYPRESS_INSTALL_BINARY 0

# not copying anything else... relying on mapping volume from the host

CMD ["./docker/local/web/run.sh"]
