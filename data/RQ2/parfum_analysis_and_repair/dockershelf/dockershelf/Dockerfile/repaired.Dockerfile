FROM dockershelf/python:3.10
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo python3.10-venv && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt requirements-dev.txt /root/
RUN pip3 install --no-cache-dir -r /root/requirements.txt -r
RUN rm -rf /root/requirements.txt /root/requirements-dev.txt

RUN echo "dockershelf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dockershelf
RUN useradd -ms /bin/bash dockershelf

USER dockershelf

RUN mkdir -p /home/dockershelf/app

WORKDIR /home/dockershelf/app

CMD tail -f /dev/null