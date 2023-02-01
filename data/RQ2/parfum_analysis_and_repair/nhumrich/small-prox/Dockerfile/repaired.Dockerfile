FROM python:alpine

RUN apk add --no-cache -u gcc make musl-dev tini

COPY requirements.txt /app/
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

CMD ["tini", "--", "python3", "-u", "/app/run.py"]
