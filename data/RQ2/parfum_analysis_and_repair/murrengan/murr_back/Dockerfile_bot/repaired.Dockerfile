FROM python:3.7-slim
WORKDIR /home/murrengan_bot

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir --upgrade pip

COPY ./requirements.txt /home/murrengan_bot/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /home/murrengan_bot
