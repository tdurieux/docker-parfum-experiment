FROM python:3.7.4-slim

RUN mkdir -p /usr/src/bot
WORKDIR /usr/src/bot

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . /usr/src/bot

ENTRYPOINT ["python3", "telesco.py"]
