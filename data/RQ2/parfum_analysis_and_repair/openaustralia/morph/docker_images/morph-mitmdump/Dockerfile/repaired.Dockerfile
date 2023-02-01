FROM python:3.6-slim-stretch
MAINTAINER Matthew Landauer <matthew@oaf.org.au>

# We're install python on its own first so that when we install python-pip
# and later uninstall python-pip and run autoremove it leaves a working python
# behind
#RUN apt-get update && apt-get install -y python

# Need to install ca-certificates otherwise won't verify ssl certificate
# of morph.io which is necessary for the connection log callback
RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install --no-install-recommends -y \
  libffi-dev \
  libssl-dev \
  libxslt1-dev \
  libjpeg62-turbo-dev \


  ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade pyOpenSSL
RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir --upgrade cffi
RUN pip install --no-cache-dir --upgrade cryptography
RUN pip install --no-cache-dir mitmproxy
RUN pip install --no-cache-dir --upgrade pyOpenSSL
RUN pip install --no-cache-dir --upgrade pyasn1
RUN pip install --no-cache-dir ipaddress
RUN pip install --no-cache-dir enum34

# Cleaning up things we don't actually need to run mitmdump.
# This won't actually reduce the size of the final image unless we combine
# all these steps into one RUN or use something like
# https://github.com/jwilder/docker-squash
RUN apt-get remove -y \
  libffi-dev   \
  libssl-dev   \
  libxslt1-dev \
  python-dev   \
  python-pip   && \
  apt-get -y autoremove

RUN apt-get clean autoclean
RUN rm -rf /var/lib/{apt,dpkg,cache,log}

# TODO: Don't run as root

COPY mitmproxy /mitmproxy
CMD ["mitmdump", "--confdir", "/mitmproxy", "--mode", "transparent", "--showhost"]
EXPOSE 8080
