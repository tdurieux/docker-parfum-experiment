FROM python:3.9-buster

# Install some basic utilities
RUN apt-get update && \
        apt-get install --no-install-recommends -y curl libcurl4-openssl-dev libmbedtls-dev && \
		ln -s /usr/lib/x86_64-linux-gnu/libmbedcrypto.so.2.* /usr/lib/x86_64-linux-gnu/libmbedcrypto.so.1 && \
		pip3 install --no-cache-dir flask pycrypto pycurl==7.44.1 && \
		pip3 install --no-cache-dir torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html && rm -rf /var/lib/apt/lists/*;

ADD src /app
COPY libmhsm_ssr.so /lib/

CMD ["/bin/bash"]
