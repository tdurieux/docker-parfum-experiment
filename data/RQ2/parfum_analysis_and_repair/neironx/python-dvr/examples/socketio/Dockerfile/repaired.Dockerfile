FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
      git \
      curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8888

CMD [ "python3", "./app.py"]
