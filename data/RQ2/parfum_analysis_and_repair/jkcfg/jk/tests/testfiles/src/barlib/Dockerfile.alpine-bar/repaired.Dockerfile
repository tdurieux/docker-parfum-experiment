FROM alpine-foo

WORKDIR /jk/modules

COPY baz.js ./baz/index.js
RUN rm bar.js
COPY baz.js foo.js