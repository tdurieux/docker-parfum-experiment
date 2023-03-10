# registry.gitlab.com/lsds-kungfu/image/kungfu:tf-cpu-ubuntu18

FROM registry.gitlab.com/lsds-kungfu/image/builder:ubuntu18 AS builder

ADD kungfu.tar.gz /kungfu
RUN cd kungfu && pip3 wheel -vvv --no-index .

FROM ubuntu:bionic AS runtime
ENV DEBIAN_FRONTEND=noninteractive
ARG SOURCES_LIST=sources.list.ustc
ADD ${SOURCES_LIST} /etc/apt/sources.list
ARG PY_MIRROR='-i https://pypi.tuna.tsinghua.edu.cn/simple'
RUN apt update && \
    apt install --no-install-recommends -y python3 python3-pip && \
    pip3 install --no-cache-dir ${PY_MIRROR} -v tensorflow && rm -rf /var/lib/apt/lists/*;
ARG KUNGFU_WHL=kungfu-0.0.0-cp36-cp36m-linux_x86_64.whl
COPY --from=builder /kungfu/${KUNGFU_WHL} /
RUN pip3 install --no-cache-dir ${PY_MIRROR} -v ${KUNGFU_WHL} && \
    rm ${KUNGFU_WHL}
