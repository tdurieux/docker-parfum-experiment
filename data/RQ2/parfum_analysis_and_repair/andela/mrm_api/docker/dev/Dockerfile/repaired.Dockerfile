FROM python:3.6

WORKDIR /app

RUN apt-get update -u && apt-get install --no-install-recommends -y \
        supervisor \
        netcat && rm -rf /var/lib/apt/lists/*;

RUN supervisord

COPY mrm_api.conf /etc/supervisor/conf.d/mrm_api.conf
COPY requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt && \
        pip install --no-cache-dir gunicorn && \
        pip install --no-cache-dir gevent
