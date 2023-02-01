FROM python:3.9

RUN apt-get update && \
    apt-get -y --no-install-recommends install vim postgresql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 80

CMD ["docker/python-dev-init.sh"]
