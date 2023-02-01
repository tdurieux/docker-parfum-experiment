FROM ubuntu:16.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
&& apt-get upgrade -y
RUN apt-get install --no-install-recommends -y python3 \
&& apt-get install --no-install-recommends -y python3-pip \
&& apt-get install --no-install-recommends -y libgmp3-dev \
&& apt-get install --no-install-recommends -y libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg \
&& apt-get install --no-install-recommends -y libmpc-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir phe \
&& pip3 install --no-cache-dir Flask-API

COPY . /app
WORKDIR /app
ENTRYPOINT ["python3"]
CMD ["server.py"]
