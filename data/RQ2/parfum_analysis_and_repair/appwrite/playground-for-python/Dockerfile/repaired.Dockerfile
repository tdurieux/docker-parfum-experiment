FROM python:3.10-alpine
WORKDIR /app
RUN apk update && apk add --no-cache git
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
CMD python playground.py
