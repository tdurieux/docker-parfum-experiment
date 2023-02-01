FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget build-essential && rm -rf /var/lib/apt/lists/*;
# build fails unless these are separate apt-get installs - don't consolidate
RUN apt-get install --no-install-recommends -y git csh python2.7 python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests

#RUN mkdir /client

##### Install MGLtools, which provides some utility scripts we need for both CPU and GPU versions
##### Need mglTools for both CPU and GPU versions - could make this a base image

RUN wget https://mgltools.scripps.edu/downloads/downloads/tars/releases/REL1.5.6/mgltools_x86_64Linux2_1.5.6.tar.gz
RUN tar -xvzf mgltools_x86_64Linux2_1.5.6.tar.gz && rm mgltools_x86_64Linux2_1.5.6.tar.gz
#RUN cd /mgltools_x86_64Linux2_1.5.6 ; tar -xvzf MGLToolsPckgs.tar.gz
RUN cd /mgltools_x86_64Linux2_1.5.6 ; ./install.sh
#RUN mv mgltools_x86_64Linux2_1.5.6 /mgtools





RUN wget https://autodock.scripps.edu/downloads/autodock-registration/tars/dist426/autodocksuite-4.2.6-src.tar.gz
RUN mkdir /autodock
RUN cd /autodock ; tar -xvzf /autodocksuite-4.2.6-src.tar.gz && rm /autodocksuite-4.2.6-src.tar.gz
RUN ls /autodock

RUN cd /autodock/src/autogrid/ ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make ; make install
RUN cd /autodock/src/autodock/ ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make ; make install


COPY requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt



COPY *.py /
COPY docking /docking/
COPY *.sh /
COPY receptors /receptors
COPY .git /.git





ENTRYPOINT ["/quarantine.sh"]

