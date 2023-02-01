FROM python:3-alpine
COPY . /usr/src/mimic
RUN pip install --no-cache-dir /usr/src/mimic
ENTRYPOINT [ "mimic" ]
