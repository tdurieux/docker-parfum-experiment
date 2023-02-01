FROM python:3.9-slim
RUN apt-get update && apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir locust
COPY perf/locust.py /perf/locust.py
WORKDIR /perf/