FROM python:3.6-slim as base

FROM base as builder

RUN apt-get update && apt-get install --no-install-recommends -y git gcc curl && mkdir /install && rm -rf /var/lib/apt/lists/*;

WORKDIR /install

COPY ./docker/prod.requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --target=/install -r /tmp/requirements.txt && \
    python -c "import nltk; nltk.download('stopwords');"

FROM base

COPY --from=builder /install /usr/local/lib/python3.6/site-packages
COPY ./scripts/bot_config.py /scripts/bot_config.py
COPY ./bot /app

WORKDIR /app

ENV TRAINING_EPOCHS=4                      \
    MAX_TYPING_TIME=4                      \
    MIN_TYPING_TIME=1                      \
    WORDS_PER_SECOND_TYPING=5              \
    ENABLE_ANALYTICS=False                 \
    ELASTICSEARCH_URL=elasticsearch:9200


CMD python /scripts/bot_config.py -r $ROCKETCHAT_URL                        \
           -an $ROCKETCHAT_ADMIN_USERNAME -ap $ROCKETCHAT_ADMIN_PASSWORD    \
           -bu $ROCKETCHAT_BOT_USERNAME -bp $ROCKETCHAT_BOT_PASSWORD        \
           -be $ROCKETCHAT_BOT_EMAIL  -bn $ROCKETCHAT_BOT_NAME    && \
    python3 -m rasa_nlu.train -c nlu_config.yml --fixed_model_name current --data data/intents/ -o models --project nlu --verbose && \
    python3 run-rocketchat.py
