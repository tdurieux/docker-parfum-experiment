FROM enigmampc/secret-network-sw-dev:v1.2.0
RUN apt update && apt install --no-install-recommends -y nodejs && npm i -g n && n i 18 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT [ "/usr/bin/node" ]
ADD devnet-init.mjs devnet-manager.mjs /
CMD [ "/devnet-init.mjs" ]
