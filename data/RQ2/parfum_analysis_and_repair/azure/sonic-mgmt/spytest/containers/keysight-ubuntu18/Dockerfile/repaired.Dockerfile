FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Pacific

RUN apt -y update
RUN apt -y upgrade

RUN apt -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python-tk && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install tk && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install tcl && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install tclx8.4 && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install tcllib && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install tcl-tls && rm -rf /var/lib/apt/lists/*;


RUN apt -y --no-install-recommends install iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install snmp && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install snmptrapd && rm -rf /var/lib/apt/lists/*;

COPY . /keysight
WORKDIR /keysight

RUN pip install --no-cache-dir -r ./spytest.txt

# https://downloads.ixiacom.com/support/downloads_and_updates/public/ixnetwork/9.10/IxNetworkAPI9.10.2007.7Linux64.bin.tgz
RUN bash ./IxNetworkAPI9.10.2007.7Linux64.bin -i silent

RUN pip install --no-cache-dir -r /opt/ixia/ixnetwork/9.10.2007.7/lib/PythonApi/requirements.txt

ENV SCID_TGEN_PATH=/opt
ENV SCID_TCL85_BIN=/opt
ENV IXNETWORK_VERSION=9.10.2007.7
ENV HLAPI_VERSION=9.10.2007.43

LABEL author="Mircea Dan Gheorghe"
LABEL version="1.0"
LABEL description="SpyTest with Keysight traffic generator"
