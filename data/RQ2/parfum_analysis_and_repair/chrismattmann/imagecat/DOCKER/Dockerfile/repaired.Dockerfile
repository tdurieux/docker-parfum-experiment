FROM continuumio/miniconda

MAINTAINER Chris Mattmann <mattmann@usc.edu>

RUN apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install apt-utils && \
    apt-get -y --no-install-recommends install git && \
    apt-get -y --no-install-recommends install tcsh && \
    apt-get -y --no-install-recommends install gpg && \
    apt-get -y --no-install-recommends install inotify-tools && \
    apt-get -y --no-install-recommends install software-properties-common && \
    apt-get -y --no-install-recommends install openjdk-8-jdk && \
    apt-get -y --no-install-recommends install imagemagick && \
    apt-get -y --no-install-recommends install tesseract-ocr-all && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir solrpy pysolr
RUN conda install -c conda-cluster apache-maven

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN mkdir /deploy
RUN git clone https://github.com/chrismattmann/imagecat.git
WORKDIR imagecat/auto
RUN ./install.sh
ENV OODT_HOME /deploy
RUN echo '. /deploy/bin/imagecatenv.sh' >> /root/.bashrc
RUN echo 'export PATH=$OODT_HOME/bin:$PATH' >> /root/.bashrc

EXPOSE 8080
EXPOSE 8081
EXPOSE 8888
EXPOSE 8000
EXPOSE 9241

COPY entrypoint_imagecatdev.sh /deploy/entrypoint_imagecatdev.sh

ENTRYPOINT ["/deploy/entrypoint_imagecatdev.sh"]
