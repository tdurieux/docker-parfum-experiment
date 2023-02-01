FROM python:3-alpine
LABEL maintainer="maurosoria@protonmail.com"

WORKDIR /root/
ADD . /root/

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    libffi-dev

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./dirsearch.py"]
CMD ["--help"]
