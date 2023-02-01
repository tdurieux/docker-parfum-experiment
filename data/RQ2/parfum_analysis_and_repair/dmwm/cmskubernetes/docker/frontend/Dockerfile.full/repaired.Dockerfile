FROM cmssw/cmsweb:20210628
MAINTAINER Valentin Kuznetsov vkuznet@gmail.com

ENV WDIR=/data
ENV USER=_frontend

# create bashs link to bash
# RUN ln -s /bin/bash /usr/bin/bashs
# add new user
RUN useradd ${USER} && install -o ${USER} -d ${WDIR}
# add user to sudoers file
RUN echo "%$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# switch to user
USER ${USER}

# add fake host certs since we'll manage them at run time
RUN mkdir -p /data/certs
RUN echo "bla" > /data/certs/hostcert.pem
RUN echo "bla" > /data/certs/hostkey.pem
RUN chmod 0600 /data/certs/hostkey.pem

# start the setup
RUN mkdir -p $WDIR
WORKDIR ${WDIR}

# pass env variable to the build
ARG CMSK8S
ENV CMSK8S=$CMSK8S
ARG CMSWEB_ENV
ENV CMSWEB_ENV=$CMSWEB_ENV

# install
ADD install.sh $WDIR/install.sh
RUN $WDIR/install.sh

# run the service
ADD run.sh $WDIR/run.sh
ADD monitor.sh $WDIR/monitor.sh
WORKDIR $WDIR
CMD ["./run.sh"]