FROM heroku/heroku:18-build

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
# Python, don't write bytecode!
ENV PYTHONDONTWRITEBYTECODE 1

# -- Install Pipenv:
RUN apt update && apt upgrade -y && apt install python3.7-dev libffi-dev -y
RUN curl --silent https://bootstrap.pypa.io/get-pip.py | python3.7

# Backwards compatility.
RUN rm -fr /usr/bin/python3 && ln /usr/bin/python3.7 /usr/bin/python3

RUN pip3 install pipenv

# -- Install Application into container:
RUN set -ex && mkdir /app

WORKDIR /app

COPY . .

RUN set -ex && pipenv install --deploy --system