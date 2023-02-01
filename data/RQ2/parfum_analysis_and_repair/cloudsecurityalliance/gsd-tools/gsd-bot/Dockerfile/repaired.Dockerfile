FROM debian:latest

MAINTAINER Josh Bressers "josh@bress.net"

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3-pip python3-dev git && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /requirements.txt

WORKDIR /

RUN pip3 install --no-cache-dir -r requirements.txt

COPY ./bot.py /
COPY ./GSD /GSD
COPY ./helpers/gitconfig /root/.gitconfig
COPY ./helpers/git-askpass-helper.sh /git-askpass-helper.sh

ENTRYPOINT [ "/bot.py" ]
