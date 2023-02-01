FROM python:3.7.6-slim

WORKDIR /cco

RUN apt-get update && apt-get install --no-install-recommends -y nano curl unzip sudo bash libpq-dev build-essential && rm -rf /var/lib/apt/lists/*;
ENV EDITOR nano

COPY . .
RUN K8_PROVIDER=aws TERRAFORM_VERSION=0.12.18 /cco/.travis.sh install-tools
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir .

ENTRYPOINT [ "/bin/bash" ]
