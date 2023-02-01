FROM python:3.10.4-bullseye

LABEL maintainer="github.com/camilamaia"

ENV PATH="~/.local/bin:${PATH}"

RUN pip install --no-cache-dir pip setuptools --upgrade

RUN pip install --no-cache-dir scanapi==2.7.0

COPY . /app

WORKDIR /app

CMD ["scanapi"]
