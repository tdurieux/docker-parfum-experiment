FROM debian:10

RUN apt update -y \
    && apt upgrade -y \
    && apt install --no-install-recommends -y \
         cmake \
         g++ \
         git \
         libssl-dev \
         make \
    && apt autoclean && rm -rf /var/lib/apt/lists/*;
