FROM python:3.6-slim

RUN apt update && apt install --no-install-recommends -y git gcc make curl && rm -rf /var/lib/apt/lists/*;

ADD ./docker/ada.requirements.txt /tmp
ADD ./ada /ada

RUN pip install --no-cache-dir -r /tmp/ada.requirements.txt

WORKDIR /ada

CMD make train && python run-telegram.py
