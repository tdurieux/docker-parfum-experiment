FROM python:3

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/joosthoeks/jhTAlib.git

RUN cd jhTAlib/ && pip3 install --no-cache-dir -e .

