FROM python:3.5

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN pip install --no-cache-dir --upgrade pip

COPY . /usr/src/app/

RUN pip install --no-cache-dir bigchaindb
RUN bigchaindb -y configure rethinkdb
