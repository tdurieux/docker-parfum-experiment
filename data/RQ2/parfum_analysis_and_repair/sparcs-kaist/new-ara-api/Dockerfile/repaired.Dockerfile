FROM python:3.7

RUN pip install --no-cache-dir --upgrade pip virtualenv awscli

ENV VIRTUAL_ENV=/newara/www/venv
RUN virtualenv -p python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apt-get update && apt-get install --no-install-recommends netcat-openbsd supervisor vim gettext -y && rm -rf /var/lib/apt/lists/*;

ADD ./ /newara/www

WORKDIR /newara/www
RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false && poetry install

RUN mkdir -p /var/log/newara/
RUN chmod +x /newara/www/.docker/run.sh
RUN chmod +x /newara/www/.docker/run-celery.sh

EXPOSE 9000
