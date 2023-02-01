FROM dockershelf/python:3.10
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo python3.10-venv git make libyaml-dev && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/python3.10 /usr/bin/python

ADD requirements.txt requirements-dev.txt /root/
RUN pip3 install --no-cache-dir -r /root/requirements.txt -r
RUN rm -rf /root/requirements.txt /root/requirements-dev.txt

RUN echo "luisalejandro ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/luisalejandro
RUN useradd -ms /bin/bash luisalejandro

USER luisalejandro

RUN mkdir -p /home/luisalejandro/app

WORKDIR /home/luisalejandro/app

CMD tail -f /dev/null