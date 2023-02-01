FROM tiangolo/uwsgi-nginx-flask:python3.8

COPY ./src /app

WORKDIR /app
RUN pip install --no-cache-dir pipenv && \
    pipenv install --system