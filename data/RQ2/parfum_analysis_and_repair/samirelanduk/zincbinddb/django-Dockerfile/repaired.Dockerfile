FROM ubuntu

RUN mkdir -p /home/app

WORKDIR /home/app

RUN apt update
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;
COPY ./requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt


COPY ./core ./core
COPY ./manage.py ./manage.py
RUN rm ./core/secrets.py

RUN sed -i s/'DEBUG = True'/'DEBUG = False'/g ./core/settings.py
RUN sed -i s/'ALLOWED_HOSTS = \[\]'/'ALLOWED_HOSTS = \["*"]'/g ./core/settings.py

RUN python3 manage.py collectstatic --noinput

CMD ["gunicorn", "--bind", ":80", "--workers", "3", "core.wsgi:application"]
