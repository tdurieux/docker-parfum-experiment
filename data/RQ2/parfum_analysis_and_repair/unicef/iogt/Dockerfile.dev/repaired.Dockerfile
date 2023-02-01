FROM python:3.8.1-buster

ENV PYTHONUNBUFFERED 1

WORKDIR /app

RUN apt update -y && apt install --no-install-recommends gettext -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
ADD ./requirements.txt ./requirements.dev.txt ./
RUN pip install --no-cache-dir -r requirements.dev.txt
