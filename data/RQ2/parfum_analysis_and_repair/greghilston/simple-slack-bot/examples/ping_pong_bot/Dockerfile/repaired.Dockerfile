FROM python:3.8-alpine

RUN apk update \ 
    && apk add --no-cache gcc git python3-dev musl-dev linux-headers libc-dev rsync zsh \ 
    findutils wget util-linux grep libxml2-dev libxslt-dev \
    && pip3 install --no-cache-dir --upgrade pip

WORKDIR /app

COPY requirements.txt /app

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

CMD ["python3", "ping_pong_bot.py"]
