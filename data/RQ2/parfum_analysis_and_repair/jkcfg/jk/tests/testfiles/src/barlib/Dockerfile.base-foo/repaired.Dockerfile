FROM scratch

WORKDIR /jk/modules

COPY foo.js bar.js ./
COPY baz.js ./baz/