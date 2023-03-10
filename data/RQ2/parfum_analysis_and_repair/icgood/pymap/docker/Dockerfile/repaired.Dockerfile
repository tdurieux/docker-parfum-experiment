FROM python:3.10-alpine

WORKDIR /pymap
COPY . .

RUN pip install --no-cache-dir -U pip wheel setuptools typing-extensions

RUN apk --update --no-cache add --virtual build-dependencies \
    build-base python3-dev libffi-dev \
  && pip install --no-cache-dir -r requirements-all.txt \
  && apk del build-dependencies

EXPOSE 143 4190 50051
HEALTHCHECK CMD ./docker/check-stale-pid.sh $KEY_FILE

ENTRYPOINT ["pymap"]
CMD ["--help"]
