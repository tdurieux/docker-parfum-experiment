FROM python:3.7.4-stretch
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv
RUN mkdir -p /sdk
WORKDIR /sdk
COPY . /sdk
