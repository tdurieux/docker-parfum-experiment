FROM python:3.5.7-slim-stretch

RUN apt-get update && apt-get install --no-install-recommends -y mc && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

RUN pip --no-cache-dir install redial
