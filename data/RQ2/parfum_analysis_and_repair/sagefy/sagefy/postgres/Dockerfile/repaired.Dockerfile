FROM postgres:12-alpine

RUN apk add --no-cache postgresql-contrib
RUN apk add --no-cache git
RUN apk add --no-cache make
RUN git clone https://github.com/gavinwahl/postgres-json-schema.git && \
  cd postgres-json-schema && \
  make install
