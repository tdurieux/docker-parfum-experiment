FROM python:3.9.0-buster
ENV SAQ_HOME /opt/ace
ENV SAQ_USER ace
ENV SAQ_GROUP ace
ENV TZ UTC
ENV DEBIAN_FRONTEND noninteractive
# by default we use uid and guid 1000 inside the linux container
# for the development environment this needs to map to whatever uid is being used
# for the bind mounts to work in linux (not sure about macos or windows yet)
# these params are set in the docker build script
ARG SAQ_USER_ID=1000
ARG SAQ_GROUP_ID=1000
ARG http_proxy
ARG https_proxy
ENV http_proxy $http_proxy
ENV https_proxy $https_proxy
COPY docker/provision/ace/etc/apt/proxy.conf /etc/apt/apt.conf.d/proxy.conf
RUN groupadd ace \
    && useradd -g ace -G sudo -m -s /bin/bash -u $SAQ_USER_ID ace \
    && sed -i -e 's/main$/main contrib non-free/g' /etc/apt/sources.list \
    && curl -f -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -f -s https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
    && apt-get -y update \
    && apt-get -y install --no-install-recommends apt-utils \
    && mkdir -p /usr/share/man/man1/ \
    && ACCEPT_EULA=Y apt-get -y install --no-install-recommends \
        ca-certificates \
        nmap \
        libmagic-dev \
        libldap2-dev \
        libsasl2-dev \
        libffi-dev \
        libimage-exiftool-perl \
        p7zip-full \
        p7zip-rar \
        unzip \
        zip \
        unrar \
        unace-nonfree \
        libxml2-dev libxslt1-dev \
        libyaml-dev \
        ssdeep \
        poppler-utils \
        rng-tools \
        wireshark-common \
        build-essential \
        file \
        less \
        nginx \
        default-jre \
        bsdmainutils \
        node-esprima \
        python2.7 \
        python-pip \
        dnsutils \
        msodbcsql17 \
        unixodbc-dev \
        automake \
        libtool \
        make \
        gcc \
        pkg-config \
        flex \
        bison \
    && mkdir /opt/signatures \
    && chown ace:ace /opt/signatures \
    && mkdir /opt/ace \
    && chown ace:ace /opt/ace \
    && mkdir /venv \
    && chown ace:ace /venv \
    && mkdir /opt/misc \
    && chown ace:ace /opt/misc && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/local/share/ca-certificates/extra
COPY ssl/extra /usr/local/share/ca-certificates/extra
COPY docker/provision/ace/install_site_CAs.sh /install_site_CAs.sh
RUN /install_site_CAs.sh \
    && update-ca-certificates \
    && python3 -m pip config set global.cert /etc/ssl/certs/ca-certificates.crt \
    && python2.7 -m pip config set global.cert /etc/ssl/certs/ca-certificates.crt \ 
    && python3 -m pip install pip virtualenv --upgrade \
    && python2.7 -m pip install officeparser 
RUN git clone https://github.com/VirusTotal/yara.git /tmp/yara \
    && cd /tmp/yara \
    && ./bootstrap.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-magic --enable-dotnet --enable-macho --enable-dex \
    && make \
    && make install \
    && ldconfig
SHELL ["/bin/bash", "-c"]
USER ace
COPY --chown=ace:ace installer/requirements-3.6.txt /venv/python-requirements-3.6.txt
RUN python3 -m virtualenv --python=python3 /venv \
    && source /venv/bin/activate \
    && pip config set global.cert /etc/ssl/certs/ca-certificates.crt \
    && pip install --no-cache-dir -r /venv/python-requirements-3.6.txt \
    && cp /etc/ssl/certs/ca-certificates.crt /venv/lib/python3.9/site-packages/certifi/cacert.pem \
    && pip uninstall -y yara-python \
    && git clone https://github.com/VirusTotal/yara-python /tmp/yara-python \
    && cd /tmp/yara-python \
    && python setup.py build --dynamic-linking \
    && python setup.py install \
    && echo 'source /venv/bin/activate' >> /home/ace/.bashrc \
    && echo 'export PATH="$PATH:/opt/ace/bin:/opt/ace"' >> /home/ace/.bashrc \
    && echo 'if [ -e /opt/ace/load_environment ]; then source /opt/ace/load_environment; fi' >> /home/ace/.bashrc
RUN git clone https://github.com/DissectMalware/XLMMacroDeobfuscator.git /tmp/XLMMacroDeobfuscator \
    && cd /tmp/XLMMacroDeobfuscator \
    && source /venv/bin/activate \
    && python setup.py install
RUN cd /opt/misc \
    && curl -f -s 'https://www.openwall.com/john/k/john-1.9.0-jumbo-1.tar.gz' -o john-1.9.0-jumbo-1.tar.gz \
    && tar zxvf john-1.9.0-jumbo-1.tar.gz \
    && cd john-1.9.0-jumbo-1/src \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -s clean && make -sj4 && rm john-1.9.0-jumbo-1.tar.gz
