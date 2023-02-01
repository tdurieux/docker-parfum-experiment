# docker run --privileged --rm tonistiigi/binfmt --install all
# docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t docker.thedrhax.pw/buildenv-blackufa .

FROM python:3.9-slim

RUN apt update \
 && apt -y --no-install-recommends install build-essential git openssh-client curl \
 && apt clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -m user
RUN echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config

ENV TZ=Europe/Moscow
USER user
WORKDIR /home/user

ENTRYPOINT ["/bin/sh"]