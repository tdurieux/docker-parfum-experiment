FROM ubuntu

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential libssl-dev make vim openssl netcat python3 python3-pip python-is-python3 wget gnutls-dev libwolfssl-dev gdbserver python2 unzip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir frida hexdump

#Install mbedTLS
#RUN wget https://github.com/ARMmbed/mbedtls/archive/v2.25.0.zip && unzip v2.25.0.zip && cd mbedtls-2.25.0 && make && make install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
WORKDIR /mnt
