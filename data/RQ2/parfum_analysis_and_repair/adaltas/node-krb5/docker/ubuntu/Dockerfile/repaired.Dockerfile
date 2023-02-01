FROM ubuntu:bionic

# Update repositories
RUN apt-get update

# Install misc
RUN apt-get install --no-install-recommends -y wget git vim sudo make && rm -rf /var/lib/apt/lists/*;

# Install compilation tools
RUN apt-get install --no-install-recommends -y python3 g++ make && rm -rf /var/lib/apt/lists/*;
#RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python

# Install Kerberos libs
RUN apt-get install --no-install-recommends -y libkrb5-dev && rm -rf /var/lib/apt/lists/*;

# Install Node.js via n
ENV NPM_CONFIG_LOGLEVEL info
RUN git clone https://github.com/tj/n /n
RUN cd /n && make install
RUN n 14
RUN n 16

RUN mkdir -p /node-krb5
COPY ./run.sh /run.sh
ENTRYPOINT ["/run.sh"]
