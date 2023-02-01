FROM python:3.7

WORKDIR /app

COPY requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

CMD ./startup.sh
