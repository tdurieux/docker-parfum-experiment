FROM python:3-alpine

RUN apk add --no-cache postgresql-dev musl libffi-dev musl-dev gcc

COPY start.sh /start.sh

RUN pip install --no-cache-dir sandman2 psycopg2 pymysql

EXPOSE 5000

CMD ["/start.sh"]
