FROM resin/raspberrypi3-debian:stretch

WORKDIR /app

# disable python buffering to console out (https://docs.python.org/2/using/cmdline.html#envvar-PYTHONUNBUFFERED)
ENV PYTHONUNBUFFERED=1

# Install dependencies
RUN echo "deb http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python-dev \
    python-pip \
    python-setuptools \
    swig \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

ENTRYPOINT [ "python", "main.py" ]
