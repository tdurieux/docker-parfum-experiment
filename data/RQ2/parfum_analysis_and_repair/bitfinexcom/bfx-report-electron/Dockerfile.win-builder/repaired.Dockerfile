FROM electronuserland/builder:14-wine

ARG NODE_VERSION="14.16.0"

ENV IS_BFX_API_STAGING=${IS_BFX_API_STAGING:-0}
ENV IS_DEV_ENV=${IS_DEV_ENV:-0}

COPY ./scripts/helpers/install-nodejs.sh ./scripts/helpers/install-nodejs.sh

RUN ./scripts/helpers/install-nodejs.sh ${NODE_VERSION} \
  # Remove the `Wine` source entry to resolve
  # the release key expiration issue for `apt-get update`
  && sed -i '/Wine/d' /etc/apt/sources.list \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    p7zip-full \
    bc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY . .

ENTRYPOINT ["./scripts/build-release.sh"]
CMD ["-w"]