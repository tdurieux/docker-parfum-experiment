FROM python:3.7.4-stretch
RUN mkdir /daas
WORKDIR /daas
COPY requirements_worker.txt /tmp/requirements_worker.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip --retries 10 --no-cache-dir install -r /tmp/requirements_worker.txt


# Generic
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential apt-transport-https && \
    apt-get install --no-install-recommends -y gnutls-bin \
        host \
        unzip \
        xauth \
        xvfb \
        zenity \
        zlib1g \
        zlib1g-dev \
        zlibc && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean


# Flash
RUN mkdir /jre
ADD ./utils/jre /jre
RUN apt-get update && \
    apt-get install --no-install-recommends -y swftools && \
    apt-get install --no-install-recommends -y \
        java-common \
        libasound2 \
        libgl1 \
        libxtst6 \
        libxxf86vm1 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN dpkg -i /jre/oracle-java8-jre_8u161_amd64.deb && \
    rm -f -v /jre/oracle-java8-jre_8u161_amd64.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Download ffdec
RUN wget -nv --no-check-certificate https://github.com/jindrapetrik/jpexs-decompiler/releases/download/version11.2.0/ffdec_11.2.0.deb -O /tmp/ffdec.deb && \
    dpkg -i /tmp/ffdec.deb && \
    rm -f /tmp/ffdec.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
