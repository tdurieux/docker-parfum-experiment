FROM reg.docker.alibaba-inc.com/teslaenv/node_env AS build
ARG TAG
ARG OSSUTIL_URL
COPY . /app
RUN /app/sbin/build.sh $TAG ${OSSUTIL_URL}