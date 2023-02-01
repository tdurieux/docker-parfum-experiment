FROM ubuntu:21.10
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt install --no-install-recommends -y python3 python3-pip python-is-python3 cmake git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir torch==1.9.1
RUN git clone https://github.com/CrayLabs/SmartRedis.git
RUN cd SmartRedis && pip install --no-cache-dir . && make lib; cd ..

