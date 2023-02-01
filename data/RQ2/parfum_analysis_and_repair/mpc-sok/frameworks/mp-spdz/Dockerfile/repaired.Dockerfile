FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  python3 \
  openssl \
  xz-utils && rm -rf /var/lib/apt/lists/*;

ADD install.sh .
RUN ["bash", "install.sh"]

add README.md test_readme.sh ./
add source/* ./MP-SPDZ/Programs/Source/
