FROM node:14.16
RUN apt-get update && apt-get install --no-install-recommends -y make gcc nasm libpng-dev && rm -rf /var/lib/apt/lists/*;
CMD [ "node" ]
