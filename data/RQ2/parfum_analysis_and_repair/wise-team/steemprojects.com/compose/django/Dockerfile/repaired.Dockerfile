FROM python:3.6

ENV PYTHONUNBUFFERED 1

# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements.txt /requirements.txt

RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir scrypt
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir steem

RUN pip install --no-cache-dir -r /requirements.txt \
    && groupadd -r django \
    && useradd -m -r -g django django

RUN apt-get install --no-install-recommends -y ruby-dev rubygems && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cron rsyslog && rm -rf /var/lib/apt/lists/*;

RUN gem install sass

COPY ./compose/django/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY . /app
RUN chown -R django /app

COPY ./compose/django/start.sh /start.sh
RUN sed -i 's/\r//' /start.sh \
    && chmod +x /start.sh \
    && chown django /start.sh

COPY ./compose/django/configure_and_run_cron.sh /configure_and_run_cron.sh
RUN chmod +x /configure_and_run_cron.sh \
    && chown django /configure_and_run_cron.sh

COPY ./compose/django/cron.sh /cron.sh
RUN chmod +x /cron.sh \
    && chown django /cron.sh

WORKDIR /app

RUN mkdir /data \
    && chown django.django /data

RUN mkdir /data/static \
    && chown django.django /data/static

RUN mkdir /data/media \
    && chown django.django /data/media

ENTRYPOINT ["/entrypoint.sh"]
