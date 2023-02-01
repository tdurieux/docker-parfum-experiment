FROM python:3.7.4-slim

WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y python-opencv netcat && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /usr/src/app

RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.sh /usr/src/app
RUN chmod +x entrypoint.sh

COPY . /usr/src/app

CMD ["./entrypoint.sh"]