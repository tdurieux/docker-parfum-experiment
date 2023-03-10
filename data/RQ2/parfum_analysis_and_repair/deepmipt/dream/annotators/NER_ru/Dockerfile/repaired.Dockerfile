FROM tensorflow/tensorflow:1.15.2-gpu

RUN apt-key del 7fa2af80  && \
    rm -f /etc/apt/sources.list.d/cuda*.list && \
    curl -f https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
    -o cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

ARG LANGUAGE=EN
ENV LANGUAGE ${LANGUAGE}

ARG CONFIG
ARG COMMIT=0.13.0
ARG PORT
ARG SRC_DIR
ARG SED_ARG=" | "

ENV CONFIG=$CONFIG
ENV PORT=$PORT

COPY ./annotators/NER_ru/requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt

RUN pip install --no-cache-dir git+https://github.com/deepmipt/DeepPavlov.git@${COMMIT}

COPY $SRC_DIR /src

WORKDIR /src

RUN python -m deeppavlov install $CONFIG

CMD gunicorn  --workers=1 --timeout 500 server:app -b 0.0.0.0:8021
