FROM ubuntu:latest
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y \
        libffi-dev libssl-dev python python-dev python-pip curl \
        git bison vim less golang wamerican && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/AFTERWAKE/IRCBots/dad/dadbot
WORKDIR /bot
COPY ./requirements.txt /bot
RUN pip install --no-cache-dir -r requirements.txt
