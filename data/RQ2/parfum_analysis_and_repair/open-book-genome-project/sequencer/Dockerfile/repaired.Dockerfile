FROM python:3.8-slim-buster
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
WORKDIR sequencer
COPY . .
RUN mkdir results
RUN pip3 install --no-cache-dir -r requirements.txt
