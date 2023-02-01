FROM ubuntu:14.04
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install --no-install-recommends -y \
        thrift-compiler \
        python-pip \
        python-dev \
        libpq-dev \
        libpq5 \
        libffi-dev && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
