FROM node:10.16.0-slim

WORKDIR /tss

RUN apt-get update && \
    apt-get install --no-install-recommends -y libssl1.1 libssl-dev curl procps && rm -rf /var/lib/apt/lists/*;

COPY ./tss-keygen/package.json /tss/

RUN npm install && npm cache clean --force;

COPY ./tss-keygen/keygen-entrypoint.sh ./tss-keygen/keygen.js ./shared/logger.js ./shared/amqp.js ./shared/crypto.js ./shared/wait.js /tss/

COPY --from=tss /tss/target/release/gg18_keygen_client /tss/

RUN mkdir /keys

ENTRYPOINT ["node", "keygen.js"]
