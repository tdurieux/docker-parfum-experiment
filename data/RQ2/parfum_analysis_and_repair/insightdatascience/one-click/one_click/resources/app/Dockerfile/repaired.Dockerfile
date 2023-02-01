ARG IMAGE=tiangolo/uwsgi-nginx-flask:python3.7

FROM $IMAGE

COPY ./app /app

RUN chmod -R 707 $STATIC_PATH

RUN pip install --no-cache-dir -r /app/requirements.txt