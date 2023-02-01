FROM {{ base_image.image }}

COPY python/requirements.txt .
COPY python/dev-requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt -r dev-requirements.txt

RUN apt-get update && \
  apt-get -y install \
    liblz4-dev

# FIXME belongs in hail-test image
RUN mkdir -p plink && \
  cd plink && \
  wget -O plink_linux_x86_64.zip https://storage.googleapis.com/hail-common/plink_linux_x86_64_20181202.zip && \
  unzip plink_linux_x86_64.zip && \
  mv plink /usr/local/bin && \
  cd .. && \
  rm -rf plink
