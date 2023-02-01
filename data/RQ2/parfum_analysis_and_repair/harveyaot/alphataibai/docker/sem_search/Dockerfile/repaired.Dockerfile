FROM tiangolo/uwsgi-nginx:python3.7-alpine3.8
RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir requests
COPY ./app /app
WORKDIR /app
