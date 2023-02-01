FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  git \
  python-dev \
  python-numpy \
  python-scipy && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText && \
  rm -rf /tmp/fastText/.git* && \
  cd /tmp/fastText && \
  make && \
  pip install --no-cache-dir .

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /
