FROM python:3.8-slim

RUN apt-get update \
&& apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN pip install --no-cache-dir pip==20.2
RUN pip install --no-cache-dir -e .
ENTRYPOINT ["python", "-m", "driver_transformer"]
