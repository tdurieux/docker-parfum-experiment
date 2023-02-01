FROM ubuntu:14.04
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install python3-pip \
                     git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir docker
RUN git clone https://github.com/h-m-s/telnet-honeypot.git
RUN mkdir -p /var/log/hms/
CMD sudo python3 /telnet-honeypot/telnet.py
