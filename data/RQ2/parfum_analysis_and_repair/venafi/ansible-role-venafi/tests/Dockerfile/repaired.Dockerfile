FROM python:3.7.10
RUN apt-get update && apt-get install -y --no-install-recommends python-pip python-setuptools python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;
