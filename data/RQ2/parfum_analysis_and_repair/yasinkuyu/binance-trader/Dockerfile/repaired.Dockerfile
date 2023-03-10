FROM python:3-alpine

RUN pip install --no-cache-dir requests

COPY app/ /app
COPY db/ /db
COPY trader.py balance.py /app/

CMD [ "python", "/app/trader.py" ]
