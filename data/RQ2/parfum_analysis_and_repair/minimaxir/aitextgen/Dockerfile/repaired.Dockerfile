FROM python:3.8.6-slim

RUN apt-get -y update && apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;

WORKDIR /

COPY requirements.txt .

# install dependencies
RUN pip --no-cache-dir install -r requirements.txt
COPY * /

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*