FROM alpine:3.12
ARG TARGETARCH=amd64

RUN apk add --no-cache \
		python3 py3-pip py3-setuptools py3-wheel \
		su-exec \
		py3-aiohttp \
		py3-ruamel.yaml \
		py3-attrs \
		bash \
		curl \
		jq && \
	curl -f -sLo yq https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_${TARGETARCH} && \
	chmod +x yq && mv yq /usr/bin/yq

COPY ./backend/requirements.txt /opt/mautrix-manager/backend/requirements.txt
WORKDIR /opt/mautrix-manager/backend
RUN apk add --no-cache --virtual .build-deps \
        python3-dev \
        build-base \
        git \
    && pip3 install --no-cache-dir -r requirements.txt \
	&& apk del .build-deps

COPY ./backend /opt/mautrix-manager/backend
RUN apk add --no-cache git && pip3 install --no-cache-dir . && apk del git \
  # This doesn't make the image smaller, but it's needed so that the `version` command works properly
  && cp mautrix_manager/example-config.yaml . && rm -rf mautrix_manager

COPY ./frontend_build /opt/mautrix-manager/frontend
COPY ./docker-run.sh /opt/mautrix-manager
ENV UID=1337 GID=1337
VOLUME /data

CMD ["/opt/mautrix-manager/docker-run.sh"]
