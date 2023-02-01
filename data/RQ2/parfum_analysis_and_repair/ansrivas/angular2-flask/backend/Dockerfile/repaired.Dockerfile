FROM alpine:latest

COPY requirements.txt run.py /server/

RUN apk --no-cache add \
    python \
    py-pip \
  && apk --update --no-cache add --virtual build-dependencies gcc python-dev libffi-dev openssl-dev build-base git \
  && pip install --no-cache-dir -r /server/requirements.txt \
  && apk del build-dependencies \
  && adduser -D app \
  && mkdir -p /server \
  && chown -R app:app /server

COPY flask_app /server/flask_app/

VOLUME /tmp

RUN chown -R app:app /server

WORKDIR /server

USER app

EXPOSE 8080

CMD ["python", "run.py"]
