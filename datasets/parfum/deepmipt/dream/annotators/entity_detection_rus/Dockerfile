FROM deeppavlov/base-gpu:0.12.1

ARG CONFIG
ARG PORT
ARG SRC_DIR
ARG SED_ARG=" | "

ARG LANGUAGE=EN
ENV LANGUAGE ${LANGUAGE}

ENV CONFIG=$CONFIG
ENV PORT=$PORT

COPY ./annotators/entity_detection_rus/requirements.txt /src/requirements.txt
RUN pip install -r /src/requirements.txt

COPY $SRC_DIR /src

WORKDIR /src
RUN python -m deeppavlov install $CONFIG

RUN sed -i "s|$SED_ARG|g" "$CONFIG"

CMD gunicorn  --workers=1 --timeout 500 server:app -b 0.0.0.0:8103
