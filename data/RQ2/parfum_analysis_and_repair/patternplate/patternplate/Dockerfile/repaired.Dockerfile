FROM marionebl/patternplate-cubicle

WORKDIR /src
ADD . ./
RUN yarn install && yarn cache clean;
RUN yarn build
