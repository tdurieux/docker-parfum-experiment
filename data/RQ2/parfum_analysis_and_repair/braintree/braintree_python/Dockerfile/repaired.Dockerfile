FROM debian:stretch

RUN apt-get update
RUN apt-get -y --no-install-recommends install python3 rake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade distribute

RUN echo 'alias python=python3' >> ~/.bashrc
WORKDIR /braintree-python
