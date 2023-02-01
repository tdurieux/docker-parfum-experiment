FROM python:3.9

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install --no-install-recommends -y libsodium-dev libsecp256k1-dev libgmp-dev nodejs npm curl && rm -rf /var/lib/apt/lists/*;

RUN python3.9 -m pip install --upgrade pip

COPY ./ /setup

WORKDIR /setup

RUN pip3 install --no-cache-dir . -U

RUN chinstrap install -l -c all

ENV PATH=~/chinstrap/bin:$PATH

WORKDIR /home

ENTRYPOINT [ "chinstrap"]
