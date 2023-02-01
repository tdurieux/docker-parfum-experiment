FROM ubuntu:15.04
MAINTAINER datawarehouse <aus-eng-data-warehouse@rmn.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -y python-dev python-pip libpq-dev vim curl mlocate && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/root
RUN cd /home/root
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN /usr/local/bin/pip install awscli

RUN apt-get install --no-install-recommends -y libmagic-dev \
    libxml2-dev \
    libxmlsec1-dev \
    swig \
    libxslt1-dev && rm -rf /var/lib/apt/lists/*;

ADD /src/python/requirements.txt /src/python/requirements.txt

RUN pip install --no-cache-dir -r /src/python/requirements.txt

# see https://github.com/onelogin/python-saml/issues/30 \
RUN if [ -f /usr/bin/xmlsec1-config ]; then sed -i 's/LIBLTDL=1 -I/LIBLTDL=1 -DXMLSEC_NO_SIZE_T -I/' /usr/bin/xmlsec1-config  ; fi
RUN pip uninstall -y dm.xmlsec.binding
RUN pip install --no-cache-dir dm.xmlsec.binding

ADD src/python /src/python

WORKDIR /src/python/dart/engine/es/

ENV PYTHONPATH=/src/python:${PYTHONPATH}

CMD ["python", "es.py"]
