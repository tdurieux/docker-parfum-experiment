FROM phusion/baseimage

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
    apt-get install -y -q --no-install-recommends \
    openssl python2.7 python-pip build-essential python-dev \
    fakeroot dpkg-dev libcurl4-openssl-dev librtmp-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip setuptools
RUN pip install --no-cache-dir requests Flask Flask-Cache
RUN pip install --no-cache-dir ndg-httpsclient

RUN pip install --no-cache-dir pyopenssl
RUN pip install --no-cache-dir pyasn1
RUN pip install --no-cache-dir retry

RUN mkdir ~/python-pycurl-openssl && \
    cd ~/python-pycurl-openssl && \
    curl -f https://dl.bintray.com/pycurl/pycurl/pycurl-7.43.0.2.tar.gz -L -O && \
    tar -xzvf pycurl-7.43.0.2.tar.gz && \
    cd pycurl-7.43.0.2 && \
    python2.7 setup.py --with-ssl install && rm pycurl-7.43.0.2.tar.gz

# https://serverfault.com/questions/348815/how-to-change-libcurl-ssl-backend-from-gnutls-to-openssl-on-ubuntu-server

# application source code including static files, templates, etc
ADD src /app/src

EXPOSE 5000

ENTRYPOINT ["python", "-u", "/app/src/app.py"]
