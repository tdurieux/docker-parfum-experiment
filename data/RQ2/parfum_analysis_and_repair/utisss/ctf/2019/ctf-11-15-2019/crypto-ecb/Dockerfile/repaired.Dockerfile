FROM ubuntu:16.04
RUN apt update
RUN apt install --no-install-recommends -y sudo python3 python3-pip libmpfr-dev libmpc-dev libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y bash socat && rm -rf /var/lib/apt/lists/*;
COPY src /

WORKDIR /

COPY start.sh /start.sh
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pycryptodome
RUN chmod 755 /start.sh

RUN adduser ret

EXPOSE 9000
CMD ["/start.sh"]
