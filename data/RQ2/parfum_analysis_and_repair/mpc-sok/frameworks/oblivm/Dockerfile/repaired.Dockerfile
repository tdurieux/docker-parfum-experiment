FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  default-jdk \
  git \
  python \
  vim && rm -rf /var/lib/apt/lists/*;

ADD README.md .

ADD install.sh .
ADD real.patch .
RUN ["bash", "install.sh"]

ADD source/mult3 /root/ObliVMLang/examples/mult3
ADD source/innerProd /root/ObliVMLang/examples/innerProd
ADD source/xtabs /root/ObliVMLang/examples/xtabs
ADD source/genInput.py /root/ObliVMLang/
