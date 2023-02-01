FROM python:3.9-slim

WORKDIR /home/python

RUN apt update && apt install --no-install-recommends -y zlib1g-dev build-essential libjpeg-dev && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD . .
RUN python manage.py migrate

STOPSIGNAL SIGINT
ENV DJANGO_SETTINGS_MODULE=get_together.environ_settings
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

