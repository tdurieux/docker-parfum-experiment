FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y \
    bluez \
    build-essential \
    libpq-dev \
    python3-dev \
    python3-pip \
    python3-smbus \
    libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

# Set our working directory
WORKDIR /usr/src/app

# Upgrade pip
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir setuptools

COPY ./requirements.txt /requirements.txt

# pip install python deps from requirements.txt on the resin.io build server
RUN pip3 install -r /requirements.txt --no-cache-dir

# Copy in actual code base
COPY django /usr/src/app/
COPY start.sh /

CMD /start.sh
