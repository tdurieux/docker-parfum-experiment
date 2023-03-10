FROM gcr.io/kaniko-project/executor:arm64-v1.6.0

ENV HOME /root
ENV USER root
ENV KANIKO_VERSION=1.6.0

ADD release/linux/arm64/kaniko-ecr /kaniko/
ENTRYPOINT ["/kaniko/kaniko-ecr"]