FROM python:3.9-slim-buster
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# get local python packages
COPY --from=ilriccio/thehistoryatlas:pylib /lib /lib

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir /lib/pybroker
RUN pip3 install --no-cache-dir /lib/tha-config
COPY . .
ENV HOST_NAME=broker
ARG test=True
ENV TESTING=$test
ENV DEBUG=True
ENV CONFIG=DEV
ENV PROD_DB_URI=
ENV DEV_DB_URI=sqlite:////etc/db/geo.db
ENV BROKER_USERNAME=guest
ENV BROKER_PASS=guest
ENV EXCHANGE_NAME=main
ENV QUEUE_NAME=geo
CMD ["python3", "-m", "app.geo"]