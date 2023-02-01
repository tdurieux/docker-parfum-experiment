FROM python:3.10-slim

ENV HOST=0.0.0.0
ENV PORT=80

WORKDIR /picobrew_pico

RUN apt-get update && \
    apt-get install --no-install-recommends -y bluez bluetooth git gcc g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip

# initialize an empty remote git repository linked folder
RUN git init && git remote add origin https://github.com/chiefwigms/picobrew_pico.git && git fetch origin --prune && git checkout --track origin/master

# Avoid cache purge by adding requirements first
COPY requirements.txt /picobrew_pico/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /picobrew_pico

CMD python3 server.py ${HOST} ${PORT}
