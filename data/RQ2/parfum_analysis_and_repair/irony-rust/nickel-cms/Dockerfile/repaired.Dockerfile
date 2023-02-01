FROM ubuntu:latest
MAINTAINER Evgeny Ukhanov <mrlsd@ya.ru>
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    sudo \
    lsb \
    gcc \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /rs
RUN curl -f -s https://static.rust-lang.org/rustup.sh | sh
WORKDIR /rs
ENTRYPOINT ["rustc"]
CMD ["--version"]
