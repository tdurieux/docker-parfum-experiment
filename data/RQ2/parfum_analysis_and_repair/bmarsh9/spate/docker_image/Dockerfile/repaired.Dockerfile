FROM python:3.7-slim

RUN apt-get update && \
  apt-get install -y --no-install-recommends gcc python3-dev libssl-dev libpq-dev -y python3-pip && \
  #apt-get remove -y gcc python3-dev libssl-dev && \
  apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

ADD . /app
WORKDIR /app
RUN mkdir /files && /app/init_container.sh && \
  pip3 install --no-cache-dir -r /app/requirements.txt

CMD ["tail", "-f", "/dev/null"]
