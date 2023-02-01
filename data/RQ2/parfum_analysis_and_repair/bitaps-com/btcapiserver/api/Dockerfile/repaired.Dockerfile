FROM ubuntu:18.04
MAINTAINER Aleksey Karpov <admin@bitaps.com>
RUN apt-get update
RUN apt install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt -y --no-install-recommends install python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3.8-dev && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python python3 /usr/bin/python3.8 1
RUN update-alternatives  --set python3 /usr/bin/python3.8
RUN update-alternatives --config python3
RUN apt-get -y --no-install-recommends install python3.8-distutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN python3 --version
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.8 get-pip.py
RUN apt-get -y --no-install-recommends install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libzbar0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip3 install --no-cache-dir gunicorn
RUN pip3 install --no-cache-dir --requirement requirements.txt
RUN mkdir /api
RUN mkdir /config
COPY ./ ./api
WORKDIR /api
ENTRYPOINT ["/usr/local/bin/gunicorn","-c", "/config/gunicorn.conf", "main:app"]