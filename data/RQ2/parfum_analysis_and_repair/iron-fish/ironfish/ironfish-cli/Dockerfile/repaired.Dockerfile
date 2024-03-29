FROM node:16.15.1-bullseye as build
ENV PATH="/root/.cargo/bin:${PATH}"

COPY ./ ./

RUN \
    apt-get update && \
    apt-get install --no-install-recommends jq rsync gcc cmake python -y && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    ./ironfish-cli/scripts/build.sh && rm -rf /var/lib/apt/lists/*;

FROM node:16.15.1-bullseye-slim
EXPOSE 8020:8020
EXPOSE 9033:9033
VOLUME /root/.ironfish
ENV NODE_ENV production
ENV PATH="/usr/src/app/bin:${PATH}"

RUN \
    apt-get update && \
    apt-get install --no-install-recommends curl libc6 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
COPY --from=build /ironfish-cli/build.cli/ironfish-cli ./app
COPY --from=build /ironfish-cli/scripts/entrypoint.sh ./app/
RUN chmod +x ./app/entrypoint.sh

WORKDIR /usr/src/app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["start", "--rpc.ipc", "--rpc.tcp"]
