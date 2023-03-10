FROM python:3.8.10-alpine
WORKDIR /home/src
RUN apk update && apk add --no-cache gcc libc-dev make git libffi-dev openssl-dev python3-dev libxml2-dev cairo-dev libxslt-dev mariadb-dev libressl-dev musl-dev cargo
RUN pip install --no-cache-dir flask pymysql cryptography==3.3.1 pymysql-pooling requests gunicorn
COPY . .
ENV DB_USER "root"
ENV DB_PASSWORD "123"
ENV RECAPTCHA_PRIV_KEY "123"
CMD ["gunicorn", "app:app", "--workers", "20", "--timeout", "2", "-b", "0.0.0.0:1005"]