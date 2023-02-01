FROM python:3.7

WORKDIR /tmp
COPY requirements.txt .

RUN apt-get update && apt-get install --no-install-recommends -y libsndfile1 ffmpeg && rm -rf /var/lib/apt/lists/*;

ENV PYTHONUNBUFFERED=True \
    PORT=${PORT:-9090} \
    PIP_CACHE_DIR=/.cache

RUN --mount=type=cache,target=$PIP_CACHE_DIR \
    pip install --no-cache-dir -r requirements.txt \
                uwsgi==2.0.19.1 \
                supervisor==4.2.2 \
                click==7.1.2 \
                git+https://github.com/heartexlabs/label-studio-ml-backend

COPY uwsgi.ini /etc/uwsgi/
COPY supervisord.conf /etc/supervisor/conf.d/

WORKDIR /app

COPY *.py /app/

EXPOSE 9090

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
