FROM electronuserland/builder:14

ARG NODE_VERSION="14.16.0"

ENV IS_BFX_API_STAGING=${IS_BFX_API_STAGING:-0}
ENV IS_DEV_ENV=${IS_DEV_ENV:-0}

COPY ./scripts/helpers/install-nodejs.sh ./scripts/helpers/install-nodejs.sh

RUN ./scripts/helpers/install-nodejs.sh ${NODE_VERSION}

COPY . .

ENTRYPOINT ["./scripts/build-ui.sh"]