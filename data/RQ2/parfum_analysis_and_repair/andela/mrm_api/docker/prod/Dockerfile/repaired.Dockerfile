FROM {{IMAGE}}

WORKDIR /app

COPY docker/prod/mrm_api.conf /etc/supervisor/conf.d/mrm_api.conf
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt && \
        pip install --no-cache-dir gunicorn && \
        pip install --no-cache-dir gevent
