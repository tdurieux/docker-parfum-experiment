FROM python:3.6-alpine
RUN set -e -x ; \
        apk add --no-cache gcc python3-dev musl-dev go ; \
        pip install --no-cache-dir nameko
RUN set -e -x ;\
        mkdir /app ;\
        adduser -S app
ADD config.yaml /app/
ADD healthcheck.py /app/
ADD metadata.json /app/
ADD payload.bin /app/
ADD exploit.go /app/
RUN set -e -x ;\
        chown -R app /app
USER app
WORKDIR /app
EXPOSE 5000
CMD nameko run --config config.yaml healthcheck
