FROM resin/rpi-raspbian:stretch

RUN [ "cross-build-start" ]

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        python3 \
        python3-dev \
        python3-pip \
        wget \
        build-essential \
        i2c-tools \
        libboost-python1.62.0 && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /app

COPY *.py ./

RUN [ "cross-build-end" ] 

ENTRYPOINT [ "python3", "-u", "./main.py" ]
