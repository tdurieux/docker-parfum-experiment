FROM python:3

RUN apt-get update && apt-get -qy --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /usr/local/bin/wait-for-it \
    && chmod +x /usr/local/bin/wait-for-it

RUN pip install --no-cache-dir barnum kafka-python mysql-connector-python requests noise

COPY . /loadgen

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
