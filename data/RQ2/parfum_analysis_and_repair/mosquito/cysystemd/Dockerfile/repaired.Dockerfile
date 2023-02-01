#############################################
FROM mosquito/fpm:centos7 as centos7

RUN yum upgrade -y
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y gcc python-pip python-devel systemd-devel && yum clean all && rm -rf /var/cache/yum
RUN pip install --no-cache-dir -U "setuptools<40"
RUN yum install -y \
    python3-pip python3-devel && rm -rf /var/cache/yum
#############################################
FROM mosquito/fpm:debian9 as debian9

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc python-pip python3-pip python-dev libsystemd-dev python3-dev \
    python3-setuptools python3-pkg-resources && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir -U setuptools
#############################################
FROM mosquito/fpm:debian10 as debian10

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc python-pip python3-pip python-dev \
    libsystemd-dev python3-dev python3-setuptools python3-pkg-resources && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir -U setuptools
#############################################
FROM mosquito/fpm:xenial as xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc python-pip python-dev libsystemd-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U "setuptools<40"
#############################################
FROM mosquito/fpm:bionic as bionic

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc python-pip python3-pip python-dev \
    libsystemd-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U "setuptools<40"
RUN pip3 install --no-cache-dir -U setuptools
#############################################
