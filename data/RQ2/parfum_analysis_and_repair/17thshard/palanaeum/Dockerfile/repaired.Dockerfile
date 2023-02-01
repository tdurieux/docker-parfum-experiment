FROM python:3-stretch

ADD . /app
ADD ./palanaeum/settings/docker.py /app/palanaeum/settings/local.py

WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg libavcodec-extra postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -Ur ./requirements.txt

ENV DJANGO_SETTINGS_MODULE palanaeum.settings.docker
CMD python3 /app/manage.py runserver_plus
