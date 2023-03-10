FROM ubuntu:xenial
WORKDIR /
RUN apt-get update && \
  apt-get -y --no-install-recommends install wget socat net-tools && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/beerpwn/ctf/blob/master/2019/UTCTF_ctf/pwn/jendys/pwnable?raw=true -O pwnable
RUN wget https://raw.githubusercontent.com/beerpwn/ctf/master/2019/UTCTF_ctf/pwn/jendys/socat.sh
RUN chmod +x socat.sh pwnable
RUN ifconfig | grep "inet "
RUN ./socat.sh
EXPOSE 2323
