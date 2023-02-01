FROM ilriccio/thehistoryatlas:ner_base
COPY /app /app

FROM python:3.9-slim-buster

# install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y netcat-openbsd gcc && \
    apt-get clean && \
    apt install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir spacy
COPY --from=0 /app/base-models /app/base-models/model-best
COPY --from=0 /app/train /app/train

WORKDIR /app
# get local python packages
COPY --from=ilriccio/thehistoryatlas:pylib /lib /lib

RUN pip3 install --no-cache-dir /lib/pybroker
RUN pip3 install --no-cache-dir /lib/tha-config
RUN pip3 install --no-cache-dir sqlalchemy
RUN pip3 install --no-cache-dir psycopg2-binary
COPY . .
ENV HOST_NAME=broker
ENV TESTING=False
ENV CONFIG=DEV
ENV PROD_DB_URI=
ENV DEV_DB_URI=
ENV TEST_DB_URI=
ENV BROKER_USERNAME=guest
ENV BROKER_PASS=guest
ENV EXCHANGE_NAME=main
ENV QUEUE_NAME=nlp
CMD ["python3", "-m", "app.nlp"]