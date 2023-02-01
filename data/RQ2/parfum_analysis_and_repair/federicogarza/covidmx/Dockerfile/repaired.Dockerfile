FROM python:3.7.2

# Install requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN pip install --no-cache-dir jupyterlab

RUN apt-get -qq update && apt-get install --no-install-recommends -y build-essential \
    libssl-dev groff \
    && rm -rf /var/lib/apt/lists/*
