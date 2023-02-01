FROM python:3.5-alpine

COPY ["changelog", "/app/src/changelog/"]
COPY ["setup.py", "/app/src/"]
RUN cd /app/src \
    && pip install --no-cache-dir . \
    && mkdir /app/workdir

WORKDIR /app/workdir
ENV PYTHONUNBUFFERED="1"

ENTRYPOINT ["changelog"]
