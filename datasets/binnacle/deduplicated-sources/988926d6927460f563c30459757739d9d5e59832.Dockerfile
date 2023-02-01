FROM python:3.6.6-alpine3.7

RUN apk add --update tini
RUN apk add --update build-base

ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_IGNORE_VIRTUALENVS=1
ENV PIPENV_NOSPIN=1
ENV PIPENV_HIDE_EMOJIS=1
ENV PYTHONPATH=/webapp

RUN pip install pipenv

RUN mkdir -p /webapp
COPY Pipfile /webapp
COPY Pipfile.lock /webapp
COPY . /webapp
WORKDIR /webapp

RUN pipenv sync --dev

EXPOSE 5000

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["pipenv", "run", "snekweb"]
