FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    pkg-config \
    libpng-dev \
    libjpeg8-dev \
    libfreetype6-dev \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    python \
    python-dev \
    python-pip \
    curl && \
    curl -f -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir -U https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.1-cp27-none-linux_x86_64.whl

COPY ./server/requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY . /src/

WORKDIR /src/static/
RUN npm install && npm run build && npm cache clean --force;

WORKDIR /src/server/

EXPOSE 8080
ENTRYPOINT python server.py
