# x86 architecture
FROM     debian:jessie

# arm (raspberry pi) architecture      
#FROM     resin/rpi-raspbian

MAINTAINER Mort Canty "mort.canty@gmail.com"

RUN apt-get upgrade && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
	    python \
	    build-essential \
	    gcc \
	    python-dev \ 
	    python-flask \
	    libffi-dev \
	    python-pip && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000

# server
RUN pip install --no-cache-dir --upgrade pip && \
        pip install --no-cache-dir --upgrade setuptools && \
        pip install --no-cache-dir google-api-python-client && \
        pip install --no-cache-dir pyCrypto && \
        apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir earthengine-api
RUN pip install --no-cache-dir --upgrade oauth2client
RUN pip install --no-cache-dir --upgrade six
#ADD     oauth2client /home/oauth2client
ADD     static /home/static
ADD     templates /home/templates  
COPY    eeMad.py /home/eeMad.py
COPY    eeWishart.py /home/eeWishart.py
COPY    eePca.py /home/eePca.py
COPY    app.py /home/app.py
RUN     chmod +x /home/app.py

WORKDIR /home
CMD     /bin/bash

