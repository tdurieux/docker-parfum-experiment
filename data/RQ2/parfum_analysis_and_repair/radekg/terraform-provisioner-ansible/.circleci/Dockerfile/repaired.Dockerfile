FROM golang:1.15.3

ARG ANSIBLE_VERSION=2.9.15

# make Apt non-interactive
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
    && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN apt update \
    && apt install --no-install-recommends -y python-pip locales \
    && pip install --no-cache-dir ansible==${ANSIBLE_VERSION} \
    && go get -u golang.org/x/lint/golint \
    && go get -u github.com/Masterminds/glide \
    && locale-gen C.UTF-8 || true && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/sh", "-c", "make lint && make test-verbose"]
