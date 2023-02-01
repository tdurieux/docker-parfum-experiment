FROM python:3-stretch
MAINTAINER Lars von Wedel <vonwedel@me.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y bluez && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "./miflora-mqtt-daemon.py", "--config_dir", "/config" ]
