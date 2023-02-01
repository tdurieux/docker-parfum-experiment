FROM golang:1.12-stretch

ENV GOCOVMODE atomic

ENV DOCKER_VERSION 18.06.0-ce

RUN apt install -y --no-install-recommends bash tar gzip procps git curl dpkg openssh-client && \
    curl -f -sSL https://download.docker.com/linux/static/stable/x86_64/docker-18.06.1-ce.tgz | tar -C /usr/bin --strip-components=1 -xzf - && rm -rf /var/lib/apt/lists/*;

RUN set -e -x \
  && mkdir -p /usr/share/coverage /usr/share/testresults /usr/share/dist \
  && go get -u golang.org/x/tools/cmd/... \
  && go get -u github.com/axw/gocov/gocov \
  && go get -u gopkg.in/matm/v1/gocov-html \
  && go get -u -t github.com/cee-dub/go-junit-report \
  && go get -u github.com/aktau/github-release


RUN curl -f -L -o /tmp/docker-$DOCKER_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
  && tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz \
  && mv /tmp/docker/* /usr/bin \
  && curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && rm /tmp/docker-$DOCKER_VERSION.tgz

VOLUME /usr/share/coverage
VOLUME /usr/share/testresults
VOLUME /usr/share/dist
