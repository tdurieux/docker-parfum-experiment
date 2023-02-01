FROM python:3.9.7-buster

RUN apt-get update
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libsodium23 && rm -rf /var/lib/apt/lists/*;

COPY ./ /keripy
WORKDIR /keripy

RUN pip install --no-cache-dir -r requirements.txt
