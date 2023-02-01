FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y python-dev libffi-dev build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . /app
ENV PYTHONPATH=${PYTHONPATH}:${PWD}
RUN pip install --no-cache-dir ".[serve]"

# Serve your ml skeleton locally with a REST API using open source dploy-kickstart
# visit https://github.com/dploy-ai/dploy-kickstart for more info
ENTRYPOINT ["make", "run-pipeline"]
