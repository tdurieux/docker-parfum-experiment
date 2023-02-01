FROM python:3.10
RUN apt-get update -y && apt-get install --no-install-recommends -y mosquitto && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -e .
RUN pip3 install --no-cache-dir pytest coverage pytest-cov
RUN py3clean .
CMD mosquitto -d && pytest -v --cov flask_mqtt