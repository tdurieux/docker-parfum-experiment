#FROM python:3.6-slim
FROM arm64v8/ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y git python3-pip firefox-geckodriver libpq-dev \
    postgresql-common && \
    apt-get autoremove && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r /requirements.txt
RUN mkdir /app
COPY src/ app/

RUN ln -s /usr/bin/python3 /usr/bin/python

ARG RELEASE
ENV RELEASE ${RELEASE}

ENV PYTHONUNBUFFERED 1

WORKDIR /app
VOLUME ["/images"]

COPY env.build /env.build
RUN ( set -a; . /env.build; set +a; python manage.py collectstatic --noinput)
RUN rm /env.build

COPY gunicorn_settings.py /gunicorn_settings.py

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8000

CMD ["gunicorn", "-c", "/gunicorn_settings.py", "wsgi:application"]
