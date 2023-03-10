FROM python:3.8.2-alpine3.11
WORKDIR /home/src
RUN apk update && apk add --no-cache gcc libc-dev make git libffi-dev openssl-dev python3-dev libxml2-dev libxslt-dev
RUN pip install --no-cache-dir flask peewee gunicorn
COPY . .
ENV FLAG "we{testflag}"
CMD ["gunicorn", "main:app", "--workers", "20", "--timeout", "2", "-b", "0.0.0.0:1002"]