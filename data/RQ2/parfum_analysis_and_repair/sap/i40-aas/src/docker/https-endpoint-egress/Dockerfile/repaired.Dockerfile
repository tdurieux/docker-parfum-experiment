FROM node:lts-alpine as builder

WORKDIR /cmd/https-endpoint-egress/

## copy package.json first and install dependencies to leverage caching
COPY cmd/https-endpoint-egress/package.json /cmd/https-endpoint-egress/
COPY cmd/https-endpoint-egress/yarn.lock /cmd/https-endpoint-egress/


## aas-logger ##
COPY pkg/aas-logger/package.json /pkg/aas-logger/
COPY pkg/aas-logger/yarn.lock /pkg/aas-logger/
RUN cd /pkg/aas-logger \
    && yarn install --production\
    && mkdir /aas-logger-production-dependencies/ \
    && cp -R node_modules /aas-logger-production-dependencies/ \
    && yarn install && yarn cache clean;


COPY pkg/aas-logger/ /pkg/aas-logger/

RUN cd /pkg/aas-logger \
    && yarn run clean \
    && yarn run build

## AMQP-Client ##
COPY pkg/AMQP-Client/package.json /pkg/AMQP-Client/
COPY pkg/AMQP-Client/yarn.lock /pkg/AMQP-Client/
RUN cd /pkg/AMQP-Client \
    && yarn install --production\
    && mkdir /AMQP-Client-production-dependencies/ \
    && cp -R node_modules /AMQP-Client-production-dependencies/ \
    && yarn install && yarn cache clean;

COPY pkg/AMQP-Client/ /pkg/AMQP-Client/

RUN cd /pkg/AMQP-Client \
    && yarn run clean \
    && yarn run build


RUN cd /cmd/https-endpoint-egress

## install & backup production dependencies
RUN yarn install --production \
    && mkdir /production-dependencies/ \
    && cp -R node_modules /production-dependencies/ && yarn cache clean;

## install dependencies
RUN yarn install && yarn cache clean;

## add & transpile sourcecode
COPY cmd/https-endpoint-egress/ /cmd/https-endpoint-egress/
RUN yarn run clean \
    && yarn run build

###################################
FROM node:lts-alpine as prod

RUN adduser -D aasuser

WORKDIR /cmd/https-endpoint-egress/

## aas-logger ##
COPY --from=builder /pkg/aas-logger/lib /pkg/aas-logger/lib
COPY --from=builder /aas-logger-production-dependencies/node_modules /pkg/aas-logger/node_modules
COPY pkg/aas-logger/package.json /pkg/aas-logger/

## AMQP-Client ##
COPY --from=builder /pkg/AMQP-Client/lib /pkg/AMQP-Client/lib
COPY --from=builder /AMQP-Client-production-dependencies/node_modules /pkg/AMQP-Client/node_modules
COPY pkg/AMQP-Client/package.json /pkg/AMQP-Client/

## copy build output from previous stage
COPY --from=builder /cmd/https-endpoint-egress/dist /cmd/https-endpoint-egress/dist
COPY --from=builder /production-dependencies/node_modules /cmd/https-endpoint-egress/node_modules
COPY cmd/https-endpoint-egress/package.json /cmd/https-endpoint-egress/

USER aasuser
EXPOSE 3000

ENTRYPOINT [ "npm", "start" ]
