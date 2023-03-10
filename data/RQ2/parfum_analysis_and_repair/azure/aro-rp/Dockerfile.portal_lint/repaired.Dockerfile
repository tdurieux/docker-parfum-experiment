ARG REGISTRY
FROM ${REGISTRY}/ubi8/nodejs-14
WORKDIR /data
USER root

COPY /portal/v2/ /data/
RUN npm install -g && npm cache clean --force;

RUN set -eux \
	&& ln -sf /data/node_modules/eslint/bin/eslint.js /usr/bin/eslint

ENTRYPOINT ["eslint"]
CMD ["--help"]