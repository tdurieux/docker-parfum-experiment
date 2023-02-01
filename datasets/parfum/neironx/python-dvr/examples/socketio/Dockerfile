FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      git \
      curl

WORKDIR /app

COPY . .

RUN pip3 install -r requirements.txt

EXPOSE 8888

CMD [ "python3", "./app.py"]
