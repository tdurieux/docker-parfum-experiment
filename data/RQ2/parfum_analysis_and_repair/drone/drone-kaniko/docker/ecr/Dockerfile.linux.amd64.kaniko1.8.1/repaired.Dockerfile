FROM gcr.io/kaniko-project/executor:v1.8.1

ENV KANIKO_VERSION=1.8.1
ADD release/linux/amd64/kaniko-ecr /kaniko/
ENTRYPOINT ["/kaniko/kaniko-ecr"]