FROM amazonlinux:latest

RUN yum -y groupinstall "Development Tools"
RUN yum install -y python27-devel python35-devel gcc findutils zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel && rm -rf /var/cache/yum
RUN curl -f https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz -o python.tar.xz && tar xf python.tar.xz && rm python.tar.xz
RUN cd Python* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
RUN cd Python* && make
RUN cd Python* && make altinstall && cd .. && rm -rf Python*
RUN curl -f -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && python3 get-pip.py && rm -f get-pip.py
RUN pip install --no-cache-dir virtualenv
RUN curl -f --silent --location https://rpm.nodesource.com/setup_6.x | bash - && yum install -y nodejs && rm -rf /var/cache/yum
RUN npm install -g grunt grunt-cli gulp bower && npm cache clean --force;
RUN virtualenv /venv
RUN python3.6 -m venv /venv3
RUN pip3 install --no-cache-dir --upgrade git+git://github.com/moduspwnens/boa-nimbus.git@v2.0.8