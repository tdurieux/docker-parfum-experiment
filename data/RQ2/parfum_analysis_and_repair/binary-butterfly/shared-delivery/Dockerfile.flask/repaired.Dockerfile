FROM ubuntu:18.04
LABEL maintainer "Ernesto Ruge <ernesto.ruge@binary-bitterfly.de>"
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV LANGUAGE en_US.utf8

RUN apt-get update && \
    apt-get install --no-install-recommends -y locales apt-utils && \
    locale-gen en_US en_US.UTF-8 && \
    echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils python3-pip python3-dev build-essential python3-venv git && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN groupadd -g 1002 webdev
RUN useradd -u 1002 -g webdev -m -d /home/webdev -s /bin/bash webdev

ENV HOME /home/webdev

RUN mkdir /app
WORKDIR /app
COPY --chown=webdev:webdev . /app

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /home/webdev/.local/bin/celery /usr/bin/celery

USER webdev
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
