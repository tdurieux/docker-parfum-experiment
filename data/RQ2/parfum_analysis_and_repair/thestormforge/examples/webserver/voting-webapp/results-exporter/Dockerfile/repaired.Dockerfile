FROM python:3.7-alpine

COPY . /

RUN apk add --no-cache postgresql-dev gcc python3-dev musl-dev && \
    pip3 install --no-cache-dir -r /requirements.txt

env FLASK_APP /app.py

ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]
