FROM ubuntu:xenial

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-dev \
        libcurl4-openssl-dev \
        libboost-python-dev \
        libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;

# Install Python packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

RUN rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoremove

RUN useradd -ms /bin/bash moduleuser
USER moduleuser

CMD [ "python3", "-u", "./main.py" ]