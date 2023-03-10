FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED 1
RUN apt-get update && \
 apt-get install --no-install-recommends -y apt-utils && \
 apt-get install --no-install-recommends -y libterm-readline-gnu-perl && \
apt-get upgrade -y && \
 apt-get install --no-install-recommends -y \
bcftools build-essential ca-certificates cpanminus curl gcc git htop libbz2-dev libcgi-session-perl \
libcurl4-openssl-dev libffi-dev liblocal-lib-perl liblzma-dev libpq-dev libssl-dev libxml2-dev make \
pkg-config python-dev python-lxml python python-dev python3 python3-dev python3-pip python3-setuptools python3-venv rabbitmq-server dh-python \
python3-wheel software-properties-common sudo tabix unzip vcftools vim virtualenvwrapper wget zip zlib1g \
zlib1g-dev zlibc \
   && apt-get autoremove -y \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir setuptools wheel statistics
RUN pip install --no-cache-dir statistics
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
#RUN git clone https://github.com/raonyguimaraes/mendelmd.git
ADD . /mendelmd
WORKDIR /mendelmd
RUN pip3 install --no-cache-dir -r requirements.txt
RUN service rabbitmq-server start
#ADD . /code/
#RUN pip3 install -U pynnotator
#RUN git clone https://github.com/raonyguimaraes/pynnotator.git
#RUN cd /code/pynnotator && python3 setup.py develop
#RUN pynnotator install
#RUN pip3 install pynnotator

#RUN git clone https://github.com/raonyguimaraes/pynnotator.git
#RUN cd /mendelmd/pynnotator && python3 setup.py install
#VOLUME /home/raony/mendelmd/compose/data /usr/local/lib/python3.6/dist-packages/pynnotator/data
#RUN pynnotator install_docker
