FROM python:3.9

RUN apt-get update && apt-get upgrade -y && apt-get install -y
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential mediainfo ffmpeg && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/src/
ADD ./requirements.txt /app/
RUN cd /app/ && pip install --no-cache-dir -r requirements.txt

ADD ./deploy/dvt/start-django-dev.sh /app/
ADD ./deploy/dvt/start-celery-worker.sh /app/
RUN chmod +x /app/*.sh
EXPOSE 8000
ADD ./src/ /app/src/
