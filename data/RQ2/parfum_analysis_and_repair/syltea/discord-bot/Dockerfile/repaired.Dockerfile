FROM python:3.8-slim

STOPSIGNAL SIGQUIT

WORKDIR /app

COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /app

CMD python3 main.py
