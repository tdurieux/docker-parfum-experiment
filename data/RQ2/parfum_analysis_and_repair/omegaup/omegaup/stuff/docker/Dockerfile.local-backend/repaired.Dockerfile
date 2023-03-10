FROM ubuntu:bionic AS base-builder

RUN apt update && \
    apt install -y --no-install-recommends \
        pkg-config cmake curl ca-certificates git gcc libc-dev zlib1g-dev && \
    /usr/sbin/update-ca-certificates && \
    curl -f --location https://dl.google.com/go/go1.14.7.linux-amd64.tar.gz | \
        tar -xz -C /usr/local && \
    apt autoremove -y && \
    apt clean && rm -rf /var/lib/apt/lists/*;
ENV PATH $PATH:/usr/local/go/bin
RUN useradd --create-home --uid 1000 --shell /bin/bash --user-group ubuntu

RUN mkdir -p /home/ubuntu/go/omegaup/bin
WORKDIR /home/ubuntu/go/omegaup

ADD go/go.mod /home/ubuntu/go/omegaup/
RUN chown -R ubuntu:ubuntu /home/ubuntu/go/
USER ubuntu

# Get dependencies.
RUN git clone --recurse-submodules https://github.com/lhchavez/git2go

RUN go get -d -tags=static github.com/lhchavez/git2go/v29@v29.0.0

RUN (cd git2go && \
     git submodule update --init && \
     ./script/build-libgit2-static.sh)


FROM base-builder AS quark-builder

COPY go/go-base go-base/
COPY go/quark quark/

RUN export QUARK_VERSION=$(cd /home/ubuntu/go/omegaup/quark && git describe --tags) && \
    go build -o bin/omegaup-grader \
      -ldflags "-X main.ProgramVersion=${QUARK_VERSION}" \
      -tags=static \
      github.com/omegaup/quark/cmd/omegaup-grader && \
    go build -o bin/omegaup-runner \
      -ldflags "-X main.ProgramVersion=${QUARK_VERSION}" \
      -tags=static \
      github.com/omegaup/quark/cmd/omegaup-runner && \
    go build -o bin/omegaup-broadcaster \
      -ldflags "-X main.ProgramVersion=${QUARK_VERSION}" \
      -tags=static \
      github.com/omegaup/quark/cmd/omegaup-broadcaster


FROM base-builder AS gitserver-builder

COPY go/go-base go-base/
COPY go/quark quark/
COPY go/githttp githttp/
COPY go/gitserver gitserver/

RUN export GITSERVER_VERSION=$(cd /home/ubuntu/go/omegaup/gitserver && git describe --tags) && \
    go build -o bin/omegaup-gitserver \
      -ldflags "-X main.ProgramVersion=${GITSERVER_VERSION}" \
      -tags=static \
      github.com/omegaup/gitserver/cmd/omegaup-gitserver


FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
      curl ca-certificates openjdk-16-jre-headless wait-for-it && \
    /usr/sbin/update-ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL \
      https://github.com/omegaup/libinteractive/releases/download/v2.0.27/libinteractive.jar \
      -o /usr/share/java/libinteractive.jar
RUN mkdir -p /etc/omegaup/{runner,grader,broadcaster,gitserver}

RUN useradd --create-home --shell=/bin/bash ubuntu

RUN mkdir -p /var/log/omegaup && chown -R ubuntu /var/log/omegaup
RUN mkdir -p /var/lib/omegaup && chown -R ubuntu /var/lib/omegaup

COPY ./etc/omegaup/runner/* /etc/omegaup/runner/
COPY ./etc/omegaup/grader/* /etc/omegaup/grader/
COPY ./etc/omegaup/broadcaster/* /etc/omegaup/broadcaster/
COPY ./etc/omegaup/gitserver/* /etc/omegaup/gitserver/

COPY --from=quark-builder /home/ubuntu/go/omegaup/bin/omegaup-runner /usr/bin/omegaup-runner
COPY --from=quark-builder /home/ubuntu/go/omegaup/bin/omegaup-grader /usr/bin/omegaup-grader
COPY --from=quark-builder /home/ubuntu/go/omegaup/bin/omegaup-broadcaster /usr/bin/omegaup-broadcaster
COPY --from=gitserver-builder /home/ubuntu/go/omegaup/bin/omegaup-gitserver /usr/bin/omegaup-gitserver

USER ubuntu
WORKDIR /var/lib

CMD ["echo", "plase choose a service to run"]
