FROM antora/antora:2.3.1

# https://github.com/Mogztter/antora-lunr
RUN yarn global add antora-lunr && yarn cache clean;
# https://github.com/Mogztter/antora-site-generator-lunr
RUN yarn global add antora-site-generator-lunr && yarn cache clean;

ENV DOCSEARCH_ENABLED=true
ENV DOCSEARCH_ENGINE=lunr

ENTRYPOINT ["docker-entrypoint.sh", "--stacktrace", "--generator", "antora-site-generator-lunr"]

LABEL description="antora/antora image with some extensions"
