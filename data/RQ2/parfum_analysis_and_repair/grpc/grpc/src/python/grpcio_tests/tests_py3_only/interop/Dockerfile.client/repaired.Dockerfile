FROM phusion/baseimage:master@sha256:65ea10d5f757e5e86272625f8675d437dd83d8db64bdb429e2354d58f5462750

RUN apt-get update -y && \
        apt-get install --no-install-recommends -y \
            build-essential \
            clang \
            python3 \
            python3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /workdir

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir /artifacts

COPY . .
RUN tools/bazel build -c dbg //src/python/grpcio_tests/tests_py3_only/interop:xds_interop_client
RUN cp -rL /workdir/bazel-bin/src/python/grpcio_tests/tests_py3_only/interop/xds_interop_client* /artifacts/

FROM phusion/baseimage:master@sha256:65ea10d5f757e5e86272625f8675d437dd83d8db64bdb429e2354d58f5462750
COPY --from=0 /artifacts ./

ENV GRPC_VERBOSITY="DEBUG"
ENV GRPC_TRACE="xds_client,xds_resolver,xds_cluster_manager_lb,cds_lb,xds_cluster_resolver_lb,priority_lb,xds_cluster_impl_lb,weighted_target_lb,ring_hash_lb,outlier_detection_lb"

RUN apt-get update -y && apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3 /usr/bin/python

ENTRYPOINT ["/xds_interop_client"]
