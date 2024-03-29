FROM python:2.7-alpine

RUN apk --no-cache add gcc musl-dev

RUN pip install --no-cache-dir dpkt regex

COPY . .

CMD ["python", "pcapfex.py"]