FROM golang:1.8

# Install required dependencies
RUN apt-get update -yq
RUN apt-get install -yq locales make xz-utils \
                        ruby ruby-dev python-pip \
                        dpkg-sig createrepo rpm \
                        zip libffi-dev

# Set default locale for the environment
RUN echo "en_US UTF-8" > /etc/locale.gen; \
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install docker client
RUN wget -q https://get.docker.com/builds/Linux/x86_64/docker-1.13.1.tgz -O /tmp/docker.tar.gz; \
    tar -xzf /tmp/docker.tar.gz -C /tmp/; \
    cp /tmp/docker/docker* /usr/bin; \
    chmod +x /usr/bin/docker*; \
    rm -rf /tmp/*

COPY Makefile /tmp/
RUN cd /tmp; \
    make deps package-deps packagecloud-deps