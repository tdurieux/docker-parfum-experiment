FROM python:2.7
MAINTAINER CloudCV Team <team@cloudcv.org>

WORKDIR /app
ENV PYTHONUNBUFFERED 1
COPY . /app
RUN mkdir -p static/
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils \
    nodejs-legacy \
    npm && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir uwsgi channels

RUN npm install -g n && npm cache clean --force;
RUN npm install -g npm@latest && npm cache clean --force;
RUN n lts

RUN pip install --no-cache-dir -r requirements.txt

CMD ["/bin/bash", "/app/docker/django/django-entrypoint.sh"]
