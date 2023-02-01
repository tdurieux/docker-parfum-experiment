FROM node:12

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsndfile1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

RUN mkdir -p /opt/binaries/
COPY binaries/wada_snr.tar.gz .
RUN tar -xzvf wada_snr.tar.gz && rm wada_snr.tar.gz
RUN mv WadaSNR /opt/binaries/
RUN rm wada_snr.tar.gz
RUN ls /opt/binaries/WadaSNR/

ARG NODE_CONFIG_ENV=default

ENV NODE_CONFIG_ENV=${NODE_CONFIG_ENV}
ENV NODE_ENV=production
EXPOSE 8080

CMD [ "node", "src/server.js","azure" ]