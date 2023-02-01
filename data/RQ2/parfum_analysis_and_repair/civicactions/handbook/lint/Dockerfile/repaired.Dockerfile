FROM node:16-alpine

ENV REVIEWDOG_VERSION=v0.13.1

RUN \
    apk add --no-cache --update \
    ca-certificates \
    bash \
    git \
    openssh \
    python3 \
    python3-dev \
    py3-pip \
    build-base && \
    pip3 install --no-cache-dir mkdocs mdx_truly_sane_lists

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY *.sh /usr/bin/

COPY config/* /usr/src/
RUN yarn install --production --non-interactive --cwd /usr/src/ && \
  yarn cache clean --force --cwd /usr/src/ \
  mkdir /src && yarn cache clean;
ENV PATH="/usr/src/node_modules/.bin:${PATH}"
WORKDIR /src

ENTRYPOINT ["/bin/bash"]
CMD []
