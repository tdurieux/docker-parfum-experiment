FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /src

ARG MODEL_DIR=/data/
ENV MODEL_DIR ${MODEL_DIR}
ARG SERVICE_PORT
ENV SERVICE_PORT ${SERVICE_PORT}

COPY ./requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt

COPY . /src

RUN mkdir /data/
RUN ls
RUN python download_model.py model sto ilm | bash
WORKDIR /data/

RUN wget https://files.deeppavlov.ai/dream/infilling/additional_ids_to_tokens.pkl
RUN wget https://files.deeppavlov.ai/dream/infilling/vocab.bpe
RUN wget https://files.deeppavlov.ai/dream/infilling/encoder.json
RUN wget https://files.deeppavlov.ai/dream/infilling/config.json

WORKDIR /src

HEALTHCHECK --interval=5s --timeout=90s --retries=3 CMD curl --fail 127.0.0.1:${SERVICE_PORT}/healthcheck || exit 1


CMD gunicorn --workers=1 server:app -b 0.0.0.0:${SERVICE_PORT} --timeout=300
