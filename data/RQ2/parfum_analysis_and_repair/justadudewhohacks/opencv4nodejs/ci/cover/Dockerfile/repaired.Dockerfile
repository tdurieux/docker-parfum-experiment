ARG TAG

FROM justadudewhohacks/opencv:${TAG}

ARG NODE_MAJOR_VERSION

RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y build-essential git curl && \
echo installing node: ${NODE_MAJOR_VERSION} && \
 curl -f -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash && \
 apt-get install --no-install-recommends -y nodejs python && \
 apt-get install --no-install-recommends lcov -y && rm -rf /var/lib/apt/lists/*;

COPY ./ ./
CMD ["bin/bash", "./ci/cover/script/run-cover.sh"]





