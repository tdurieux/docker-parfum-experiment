FROM python:3.8-slim
MAINTAINER Frojd

ENV PYTHONUNBUFFERED=1 \
    REQUIREMENTS=requirements.txt

RUN apt-get update \
    && apt-get install --no-install-recommends -y netcat gcc libpq-dev \
    && apt-get install --no-install-recommends -y binutils libproj-dev \
    && apt-get install --no-install-recommends -y gettext \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD . /app/

RUN pip install --no-cache-dir --upgrade pip \
    && pip install -r $REQUIREMENTS --no-cache-dir

EXPOSE 8080

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["runserver"]
