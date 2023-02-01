# TODO: can this be merged with the main project Dockerfile?

FROM ubuntu:20.04
LABEL Name=tinychain Version=0.0.2

RUN apt-get -y update && apt-get install --no-install-recommends -y sudo curl && rm -rf /var/lib/apt/lists/*;

RUN ln -snf /usr/share/zoneinfo/America/New_York /etc/localtime && echo America/New_York > /etc/timezone

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN apt-get install --no-install-recommends -y gnupg2 ca-certificates apt-utils software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --fetch-key https://repo.arrayfire.com/GPG-PUB-KEY-ARRAYFIRE-2020.PUB

RUN echo "deb [arch=amd64] https://repo.arrayfire.com/ubuntu focal main" | tee /etc/apt/sources.list.d/arrayfire.list

RUN apt-get update && apt-get install --no-install-recommends -y arrayfire && rm -rf /var/lib/apt/lists/*;

COPY host /host

RUN . $HOME/.cargo/env && cargo install tinychain --features=tensor --path=/host

RUN mkdir /data

RUN ln -s $HOME/.cargo/bin/tinychain tinychain
