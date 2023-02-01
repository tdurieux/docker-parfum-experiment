FROM ubuntu:20.04

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        exiftool \
        ffmpeg \
        gnupg \
        wget \
        libpq-dev \
    && echo 'deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main' > /etc/apt/sources.list.d/deadsnakes.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6A755776 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.9 \
        python3.9-dev \
        python3.9-distutils \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO /usr/local/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/81b1373f/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it

RUN ln -s /usr/bin/python3.9 /usr/local/bin/python \
    && ln -s /usr/bin/python3.9 /usr/local/bin/python3 \
    && wget -qO - https://bootstrap.pypa.io/get-pip.py | python3.9

# # TODO: Remove for initial release / development only
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        less \
        nano \
        netcat \
        telnet \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir ipdb ipython remote-pdb

RUN mkdir /app
WORKDIR /app
COPY app/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt \
    # TODO: fix for ipython, broken on jedi 0.18.0, remove for initial release / dev only
    && pip install --no-cache-dir jedi==0.17.2

COPY app /app/
COPY image/ /

ENTRYPOINT ["/entrypoint.sh"]
CMD []
