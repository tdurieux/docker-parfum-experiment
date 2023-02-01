FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated wget && rm -rf /var/lib/apt/lists/*

WORKDIR /src

ARG PRETRAINED_MODEL_FNAME
ENV PRETRAINED_MODEL_FNAME ${PRETRAINED_MODEL_FNAME}
ARG SERVICE_PORT
ENV SERVICE_PORT ${SERVICE_PORT}
ARG TOKENIZER_NAME_OR_PATH
ENV TOKENIZER_NAME_OR_PATH ${TOKENIZER_NAME_OR_PATH}

RUN mkdir /data/

RUN wget -c -q https://files.deeppavlov.ai/deeppavlov_data/${PRETRAINED_MODEL_FNAME} -P /data/

COPY ./requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt

COPY . /src

CMD gunicorn --workers=1 server:app -b 0.0.0.0:${SERVICE_PORT} --timeout=300

