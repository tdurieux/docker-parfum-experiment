FROM debian:buster-20191224

ARG go_pkg_url

RUN apt-get update && apt-get -y --no-install-recommends install build-essential curl ca-certificates devscripts dh-systemd && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s -k $go_pkg_url -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

RUN groupadd -g 1000 jenkins-build && useradd -u 1000 -g 1000 jenkins-build
RUN chmod 777 /home

CMD ["/usr/bin/sshd", "-D"]

