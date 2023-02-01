FROM dockershelf/node:14
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg dirmngr sudo && rm -rf /var/lib/apt/lists/*;

RUN dirmngr --debug-level guru

RUN gpg --batch --lock-never --no-default-keyring \
        --keyring /usr/share/keyrings/yarn.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 23E7166788B63E1E
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash moviebox
RUN echo "moviebox ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/moviebox

USER moviebox

RUN mkdir -p /home/moviebox/app

WORKDIR /home/moviebox/app

CMD tail -f /dev/null
