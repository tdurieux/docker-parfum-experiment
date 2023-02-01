FROM python:3.7.0-alpine3.8

WORKDIR ['/app/slacker']

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "slacker.py"]
