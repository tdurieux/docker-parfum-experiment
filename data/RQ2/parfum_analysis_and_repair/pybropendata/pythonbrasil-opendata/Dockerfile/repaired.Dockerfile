FROM python:3.9-slim-buster

RUN apt-get update -y \
    && apt-get install --no-install-recommends gcc -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /pybr_opendata/requirements.txt

WORKDIR /pybr_opendata/

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /pybr_opendata/requirements.txt
