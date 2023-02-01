FROM python:3.7

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential libssl-dev default-libmysqlclient-dev python-pip python-dev \
    && apt-get -y clean all && rm -rf /var/lib/apt/lists/*;

COPY . /home/app/vault

RUN pip install --no-cache-dir -r /home/app/vault/requirements.txt

WORKDIR /home/app/vault
