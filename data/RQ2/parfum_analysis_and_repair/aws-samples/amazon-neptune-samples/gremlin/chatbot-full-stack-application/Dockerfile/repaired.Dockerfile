FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-pip python3-dev curl sudo \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 --no-cache-dir install --upgrade pip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -f -sL https://deb.nodesource.com/setup_current.x | sudo -E bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y nodejs build-essential \
    && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt update && sudo apt install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;


COPY ./deployment/ /deployment
COPY ./code/web-ui/neptune-chatbot/ /neptune-chatbot
ENV FRONTEND_PATH="/neptune-chatbot"
WORKDIR /deployment

RUN chmod +x run.sh

EXPOSE 3000

CMD "/deployment/run.sh"