FROM node:lts
RUN apt-get update && apt-get install -y --no-install-recommends dos2unix && rm -rf /var/lib/apt/lists/*;
RUN yarn global add azurite@2.6.5
RUN dos2unix /usr/local/share/.config/yarn/global/node_modules/azurite/bin/azurite
ENTRYPOINT azurite