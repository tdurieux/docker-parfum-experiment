FROM python:3.5

ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get -y --no-install-recommends install gettext && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir --upgrade -r requirements.txt
RUN pip install --no-cache-dir django-debug-toolbar

ENTRYPOINT ["./docker-entrypoint.sh"]
