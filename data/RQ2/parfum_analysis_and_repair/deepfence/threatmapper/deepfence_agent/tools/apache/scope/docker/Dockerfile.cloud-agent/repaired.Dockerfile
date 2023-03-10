FROM alpine:3.14.2
LABEL maintainer="Deepfence Inc"
LABEL deepfence.role=system

ENV CHECKPOINT_DISABLE=true DOCKERVERSION=20.10.8 MGMT_CONSOLE_PORT=443

WORKDIR /home/deepfence
RUN apk add --no-cache --update bash conntrack-tools iproute2 util-linux curl bind-tools grep tar \
    && curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
    && rm docker-${DOCKERVERSION}.tgz \
    && curl -fsSLOk https://github.com/deepfence/vessel/releases/download/v0.5.7/vessel-v0.5.7-linux-amd64.tar.gz \
    && tar -xzf vessel-v0.5.7-linux-amd64.tar.gz \
    && mv vessel /usr/local/bin/ \
    && rm -rf vessel-v0.5.7-linux-amd64.tar.gz \
    && curl -fsSLOk https://github.com/containerd/nerdctl/releases/download/v0.18.0/nerdctl-0.18.0-linux-amd64.tar.gz \
    && tar Cxzvvf /usr/local/bin nerdctl-0.18.0-linux-amd64.tar.gz \
    && rm nerdctl-0.18.0-linux-amd64.tar.gz \
	&& rm -rf /var/cache/apk/*
COPY ./deepfence_exe /home/deepfence/
# COPY ./capture_topology_container.sh /home/deepfence/capture_start.sh
# RUN cp /home/deepfence/capture_start.sh /home/deepfence/capture_stop.sh \
#     && cp /home/deepfence/capture_start.sh /home/deepfence/capture_status.sh \
#     && chmod +x /home/deepfence/*.sh
ENTRYPOINT ["/home/deepfence/deepfence_exe"]