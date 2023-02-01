FROM cmssw/cmsweb:20210628
MAINTAINER Valentin Kuznetsov vkuznet@gmail.com

ENV WDIR=/data
ENV USER=_couchdb
ADD install.sh $WDIR/install.sh

# add new user
RUN useradd ${USER} && install -o ${USER} -d ${WDIR}
# add user to sudoers file
RUN echo "%$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# switch to user
USER ${USER}

# start the setup
RUN mkdir -p $WDIR
WORKDIR ${WDIR}

# pass env variable to the build
ARG CMSK8S
ENV CMSK8S=$CMSK8S

# install
RUN $WDIR/install.sh

# get binary build of couchdb exporter
RUN curl -ksLO https://github.com/gesellix/couchdb-prometheus-exporter/releases/download/v27.0.0/couchdb-prometheus-exporter_27.0.0_Linux_x86_64.tar.gz
RUN tar xfz couchdb-prometheus-exporter_27.0.0_Linux_x86_64.tar.gz
RUN rm couchdb-prometheus-exporter_27.0.0_Linux_x86_64.tar.gz LICENSE README*.md
ENV PATH="${WDIR}:${PATH}"

# build couchdb exporter
#ENV GOPATH=$WDIR/gopath
#RUN mkdir -p $GOPATH
#ENV PATH="${GOROOT}/bin:${WDIR}:${PATH}"
#RUN go get github.com/golang/glog
#RUN go get github.com/namsral/flag
##RUN go get github.com/gesellix/couchdb-prometheus-exporter/glogadapt
#RUN go get github.com/gesellix/couchdb-prometheus-exporter/lib
#RUN go get github.com/gesellix/couchdb-prometheus-exporter

# add necessary scripts
ADD run.sh $WDIR/run.sh
ADD monitor.sh $WDIR/monitor.sh

# setup final environment
USER $USER
WORKDIR $WDIR
CMD ["./run.sh"]
