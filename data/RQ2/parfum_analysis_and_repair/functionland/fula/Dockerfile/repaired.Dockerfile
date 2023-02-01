FROM node:16 as fula-pack
ENV NODE_ENV=production


COPY ./ /opt/fula
WORKDIR /opt/fula

RUN npm install -g @microsoft/rush && rush update && rush rebuild --verbose && npm cache clean --force;


FROM node:16 as examples
ENV NODE_ENV=production
ARG EXAMPLE_PATH

COPY --from=fula-pack /opt/fula /opt/fula
WORKDIR $EXAMPLE_PATH

RUN npm install && npm cache clean --force;

CMD npm start
