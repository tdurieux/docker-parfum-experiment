FROM arm32v7/python:2-alpine

WORKDIR /app
ADD requirements.txt /app
RUN apt-get update && apt-get install --no-install-recommends -y \
  python-dev \
  python-pip \
  python-smbus \
  libfreetype6-dev \
  libjpeg-dev \
  ttf-dejavu-core \
  build-essential \
  gcc \
  vim \
  iputils-ping \
  python-imaging && pip install --no-cache-dir --index-url=https://pypi.python.org/simple/ --upgrade pip && apt-get purge -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
CMD /bin/bash
