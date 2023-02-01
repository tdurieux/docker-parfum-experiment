FROM python:3.7.9-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
  gcc \
  pv \
  git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir jupyter
RUN pip install --no-cache-dir jupyterlab

RUN git clone https://github.com/usc-isi-i2/table-linker

RUN pip install --no-cache-dir -e table-linker

