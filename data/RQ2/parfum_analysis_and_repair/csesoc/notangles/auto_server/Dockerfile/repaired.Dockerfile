FROM python:3.10.5-slim-buster

WORKDIR /auto_server

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 50051

CMD [ "python3", "server.py"]
