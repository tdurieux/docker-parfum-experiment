FROM registry.jiagouyun.com/middlewares/dataflux-func:base-dataflux

MAINTAINER Yiling Zhou <zyl@jiagouyun.com>

ARG TARGETARCH

ENV TARGETARCH ${TARGETARCH}

# Build project
WORKDIR /usr/src/app
COPY . .

# 由于buildx 在arm64 下执行npm run build 速度太慢
# 暂时改为本机执行npm run build，并把dist 目录也提交到git库中，不再由服务器进行构建
# RUN ln -s /usr/src/base/node_modules ./node_modules && \
#     ln -s /usr/src/base/client/node_modules ./client/node_modules && \
#     cd /usr/src/app/client && \
#         npm run build
RUN ln -s /usr/src/base/node_modules ./node_modules && \
    ln -s /usr/src/base/client/node_modules ./client/node_modules

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

# Run Web server
# EXPOSE 8088
# CMD ./run-server.sh
# Run Worker
# CMD ./run-worker.sh
# Run Worker beat
# CMD ./run-beat.sh