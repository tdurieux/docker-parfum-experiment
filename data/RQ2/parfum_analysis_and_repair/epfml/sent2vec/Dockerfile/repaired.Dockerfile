FROM ubuntu

RUN mkdir -p /opt/sent2vec/src
ADD setup.py /opt/sent2vec/
ADD src /opt/sent2vec/src/
ADD Makefile /opt/sent2vec/
ADD requirements.txt /opt/sent2vec/

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip python3-dev build-essential libevent-pthreads-2.1-6 && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/sent2vec

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

RUN pip3 install --no-cache-dir .
RUN make
