FROM python:3.8

COPY requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /app
COPY . .

CMD python3 server.py

