FROM python:2.7-slim
ADD . /src
WORKDIR /src
RUN apt-get update && apt-get --yes --no-install-recommends --force-yes install build-essential python-dev libpng12-dev pkg-config libfreetype6-dev && pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;
CMD ["make", "run"]
