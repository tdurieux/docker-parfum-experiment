FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y python-dev libffi-dev build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . /app
ENV PYTHONPATH=${PYTHONPATH}:${PWD}
RUN pip install --no-cache-dir -e ".[test]"
ENTRYPOINT ["make", "test"]
