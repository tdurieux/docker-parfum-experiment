FROM alpine:3.14
ARG DEFAULT_DEPLOY_STACK=technocore

COPY --from=docker:20 / /
COPY --from=docker/compose:1.29.2 / /

RUN apk add --no-cache bash grep curl coreutils openssl mosquitto-clients git python3 py3-pip py3-jwt-cli jq jsonnet vim
RUN pip3 install --no-cache-dir --ignore-installed distlib pipenv

RUN curl -f -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 --output /usr/local/bin/yq && \
    chmod -R o+xr /usr/local/bin

WORKDIR /var/lib/technocore
COPY ${DEFAULT_DEPLOY_STACK}.stack.sh /var/lib/technocore/stack.sh
RUN /var/lib/technocore/stack.sh

COPY bin/ /usr/local/technocore/bin
ENV PATH="/usr/local/technocore/bin:${PATH}"

COPY sidecars/ /usr/local/bin/sidecars
COPY lib/ /usr/local/lib/technocore
RUN cd /tmp/ && \
    curl -f -L --output /tmp/drone.tar.gz https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz && \
    tar -xzf /tmp/drone.tar.gz && \
    install -t /usr/local/bin drone && \
    rm -rf /tmp/* && rm /tmp/drone.tar.gz
#COPY services/ /var/lib/technocore

#ENTRYPOINT ["go-init"]
#CMD ["/usr/local/bin/sidecars/create-secret.sub"]
