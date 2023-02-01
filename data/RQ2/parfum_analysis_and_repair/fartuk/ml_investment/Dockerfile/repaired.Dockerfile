FROM python:3.7-slim

RUN apt-get update && apt-get -y --no-install-recommends install libgomp1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . ./
RUN pip install --no-cache-dir .

CMD pytest

