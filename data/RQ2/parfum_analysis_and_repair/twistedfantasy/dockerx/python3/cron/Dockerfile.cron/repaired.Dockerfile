ARG IMAGE
FROM $IMAGE
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

ARG APP_PATH
ARG CRON_PATH

ENV PYTHONUNBUFFERED 1

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

RUN apt-get update && apt-get -y --no-install-recommends install cron && rm -rf /var/lib/apt/lists/*;

ADD cron/crontab-notifier $CRON_PATH/
RUN chmod -R 0644 $CRON_PATH

RUN pip install --no-cache-dir pipenv==2018.11.26

COPY Pipfile ssm/Pipfile.lock ./
RUN pipenv install --system --deploy
COPY ./ .

CMD printenv | grep -v "no_proxy" >> /etc/environment && cron -f
