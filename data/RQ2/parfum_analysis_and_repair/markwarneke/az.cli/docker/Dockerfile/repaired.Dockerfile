FROM python:3.7-alpine

COPY requirements.txt /

RUN apk --update --no-cache add python py-pip openssl ca-certificates py-openssl wget
RUN apk --update --no-cache add --virtual build-dependencies libffi-dev openssl-dev python-dev py-pip build-base \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt \
  && apk del build-dependencies


COPY src/ /app
COPY docker/import.py /app
WORKDIR /app

# Argument to python command
ENTRYPOINT ["python", "-i", "import.py"]
