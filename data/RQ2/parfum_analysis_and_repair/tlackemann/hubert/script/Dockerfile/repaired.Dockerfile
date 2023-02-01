FROM ubuntu:14.04.3

# Install necessary packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  curl \
  python-numpy \
  python-pip \
  python-scipy \
  git && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install pip
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && \
  rm get-pip.py

# Install cassandra-driver
RUN pip install --no-cache-dir cassandra-driver

# Install scikit-learn
RUN pip install --no-cache-dir scikit-learn

# Install Hue package
RUN pip install --no-cache-dir phue

# Install daemon package
RUN pip install --no-cache-dir python-daemon

RUN pip install --no-cache-dir pika

# Setup the application
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY index.py /usr/src/app

CMD [ "python", "index.py" ]
