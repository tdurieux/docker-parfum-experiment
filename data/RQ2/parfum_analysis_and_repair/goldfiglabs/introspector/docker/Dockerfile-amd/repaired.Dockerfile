FROM python:3.9-slim

ADD https://github.com/amacneil/dbmate/releases/download/v1.11.0/dbmate-linux-amd64 /app/dbmate
RUN chmod a+x /app/dbmate
COPY requirements.txt /app/
COPY migrations /app/migrations
WORKDIR /app/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000/tcp
COPY introspector.py /app/
COPY introspector /app/introspector
LABEL introspector-cli=0.0.1
ENV AWS_MAX_ATTEMPTS=5
ENV AWS_RETRY_MODE=adaptive

ENTRYPOINT ["/app/introspector.py", "serve"]