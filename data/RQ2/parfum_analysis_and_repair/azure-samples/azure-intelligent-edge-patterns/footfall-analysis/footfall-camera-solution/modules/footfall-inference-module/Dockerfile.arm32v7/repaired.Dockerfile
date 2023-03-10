FROM arm32v7/ubuntu:16.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    libboost-python-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    python3.5 \
    python3-pip \
    wget \
    inetutils-traceroute \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Repository of pre-built wheels for ARM
RUN echo '[global]' >> /etc/pip.conf && \
    echo 'extra-index-url=https://www.piwheels.org/simple' >> /etc/pip.conf

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir https://modelmgmtreswcus.azureedge.net/wheels/azure_iothub_device_client-1.4.3-py3-none-linux_armv7l.whl

RUN wget -O /THIRDPARTYNOTICE.TXT https://modelmgmtreswcus.azureedge.net/texts/THIRDPARTYNOTICE.TXT; \
find / -type f -name 'copyright' -print | while read filename; do   \
libname=$(echo "$filename" | awk -F/ '{ print $(NF-1) }' ) ; \
echo "" ; \
echo "---------------------------------------------"; \
echo "Package - $libname" ; \
echo "---------------------------------------------"; \
cat "$filename"; \
done >> /THIRDPARTYNOTICE.TXT


WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y libgstreamer1.0 gstreamer1.0-plugins-good gstreamer1.0-tools && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade setuptools

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN pip3 --default-timeout=1000 --no-cache-dir install azure-storage-blob==1.0.0

COPY . .

# RUN useradd -ms /bin/bash moduleuser
# USER moduleuser

CMD [ "python3", "-u", "./main.py" ]