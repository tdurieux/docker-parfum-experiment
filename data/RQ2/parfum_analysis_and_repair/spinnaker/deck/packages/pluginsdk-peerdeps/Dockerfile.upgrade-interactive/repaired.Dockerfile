FROM alpine

RUN apk add --no-cache --update nodejs yarn
COPY convert-peerdeps.js /work/scripts/
WORKDIR /work/scripts
RUN yarn init -y && yarn add -D lodash yargs && yarn cache clean;

WORKDIR /work

# The pluginsdk-peerdeps package should be mounted in the container at /mnt/pluginsdk-peerdeps

CMD cp /mnt/pluginsdk-peerdeps/package.json . && \
  /work/scripts/convert-peerdeps.js --from-peerdeps --input package.json --output package.json && \
  yarn && \
  yarn upgrade-interactive --latest && \
  /work/scripts/convert-peerdeps.js --to-peerdeps --input package.json --output package.json && \
  cp package.json /mnt/pluginsdk-peerdeps/package.json
