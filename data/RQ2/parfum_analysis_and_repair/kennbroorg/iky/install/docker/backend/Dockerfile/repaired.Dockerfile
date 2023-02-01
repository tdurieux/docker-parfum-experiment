FROM python:3.9.2-buster

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt

COPY ./backend .

RUN sed -i "s/CELERY_BROKER_URL.*/CELERY_BROKER_URL = 'redis:\/\/redis:6379\/0'/g" /app/factories/configuration.py
RUN sed -i "s/CELERY_RESULT_BACKEND.*/CELERY_RESULT_BACKEND = 'redis:\/\/redis:6379\/0'/g" /app/factories/configuration.py

RUN sed -i "s/redis:\/\/localhost/redis:\/\/redis/g" /app/factories/celery_config.py

# supervisor installation &&
# create directory for child images to store configuration in
RUN apt-get update && apt-get -y --no-install-recommends install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d && rm -rf /var/lib/apt/lists/*; # RUN apt-get update && \
#     apt-get -y upgrade




# supervisor base configuration
ADD install/docker/backend/supervisor.conf /etc/supervisor.conf

EXPOSE 5000

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
