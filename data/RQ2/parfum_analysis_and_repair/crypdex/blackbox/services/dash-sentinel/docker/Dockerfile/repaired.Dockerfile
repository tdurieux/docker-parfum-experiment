FROM python:3.7.4-slim-stretch

RUN apt-get update && \
  apt-get install --no-install-recommends git build-essential -y && \
  git clone https://github.com/dashpay/sentinel.git && \
  cd sentinel && \
  pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

COPY sentinel.conf /sentinel/