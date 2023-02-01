FROM ubuntu:latest

MAINTAINER Tanay Pant "tanay1337@gmail.com"


RUN apt-get update -y && apt-get install --no-install-recommends -y gcc automake autoconf libtool bison swig python-dev libpulse-dev espeak multimedia-jack && rm -rf /var/lib/apt/lists/*;

COPY . /app

WORKDIR /app

COPY melissa/data/memory.db.default melissa/data/memory.db

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["FLASK_APP=melissa/__main__.py", "flask", "run"]

