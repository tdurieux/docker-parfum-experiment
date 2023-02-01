FROM python:3.7-slim-buster

RUN apt-get update \
        && apt-get install --no-install-recommends -y build-essential build-essential python3.7-dev python-igraph && rm -rf /var/lib/apt/lists/*;

COPY . /pimbook
WORKDIR "/pimbook"

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["bash"]
