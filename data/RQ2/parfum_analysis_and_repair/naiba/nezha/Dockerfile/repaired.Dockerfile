FROM ubuntu:focal

ENV TZ="Asia/Shanghai"

ARG TARGETOS
ARG TARGETARCH

COPY ./script/entrypoint.sh /entrypoint.sh

RUN export DEBIAN_FRONTEND="noninteractive" && \
    apt update && apt install --no-install-recommends -y ca-certificates tzdata && \
    update-ca-certificates && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure tzdata && \
    chmod +x /entrypoint.sh && rm -rf /var/lib/apt/lists/*;

WORKDIR /dashboard
COPY ./resource ./resource
COPY dist/dashboard-${TARGETOS}-${TARGETARCH} ./app

VOLUME ["/dashboard/data"]
EXPOSE 80 5555
ENTRYPOINT ["/entrypoint.sh"]