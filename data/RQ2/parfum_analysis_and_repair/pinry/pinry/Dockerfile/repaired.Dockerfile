FROM python:3.7-stretch
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY . /app

# config nodejs
RUN curl -f -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
RUN bash n 14
RUN npm -g install yarn && npm cache clean --force;

WORKDIR /app
RUN pip install --no-cache-dir poetry
RUN poetry install
RUN rm -fr /app/*
