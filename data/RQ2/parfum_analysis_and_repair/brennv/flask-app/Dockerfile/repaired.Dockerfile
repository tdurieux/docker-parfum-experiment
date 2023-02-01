FROM python:3-alpine

# RUN apk add --update bash curl git && rm -rf /var/cache/apk/*

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "app.py"]
