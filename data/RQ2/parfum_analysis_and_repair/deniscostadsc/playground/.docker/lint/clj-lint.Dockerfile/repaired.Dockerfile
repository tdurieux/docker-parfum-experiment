FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y \
    curl \
    unzip && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y




RUN curl -f -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo
RUN chmod +x install-clj-kondo
RUN ./install-clj-kondo

RUN mkdir /code
WORKDIR /code
