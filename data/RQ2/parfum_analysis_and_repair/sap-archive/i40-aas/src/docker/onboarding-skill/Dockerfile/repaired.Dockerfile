FROM node:lts-alpine as builder

WORKDIR /cmd/onboarding-skill/


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
    && yarn run build && yarn cache clean;

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
    && yarn run build && yarn cache clean;


## Onboarding Service ##
COPY cmd/onboarding-skill/package.json /cmd/onboarding-skill/
COPY cmd/onboarding-skill/yarn.lock /cmd/onboarding-skill/
RUN cd /cmd/onboarding-skill

## install & backup production dependencies
RUN yarn install --production \
    && mkdir /production-dependencies/ && yarn cache clean;
RUN  cp -R node_modules /production-dependencies/

## install dependencies
RUN yarn install && yarn cache clean;

## add & transpile sourcecode
COPY cmd/onboarding-skill/ /cmd/onboarding-skill/
RUN yarn run clean \
    && yarn run build && yarn cache clean;

###################################
FROM node:lts-alpine as prod

RUN adduser -D aasuser

WORKDIR /cmd/onboarding-skill/

## aas-logger ##
COPY --from=builder /pkg/aas-logger/lib /pkg/aas-logger/lib
COPY --from=builder /aas-logger-production-dependencies/node_modules /pkg/aas-logger/node_modules
COPY pkg/aas-logger/package.json /pkg/aas-logger/

## AMQP-Client ##
COPY --from=builder /pkg/AMQP-Client/lib /pkg/AMQP-Client/lib
COPY --from=builder /AMQP-Client-production-dependencies/node_modules /pkg/AMQP-Client/node_modules
COPY pkg/AMQP-Client/package.json /pkg/AMQP-Client/


## Onboarding Service ##
COPY --from=builder /cmd/onboarding-skill/dist /cmd/onboarding-skill/dist
COPY --from=builder /production-dependencies/node_modules /cmd/onboarding-skill/node_modules
COPY cmd/onboarding-skill/package.json /cmd/onboarding-skill/

USER aasuser
EXPOSE 3000

ENTRYPOINT [ "npm", "start" ]
