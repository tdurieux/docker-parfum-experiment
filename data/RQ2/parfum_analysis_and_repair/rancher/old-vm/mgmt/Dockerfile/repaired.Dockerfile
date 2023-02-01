FROM ubuntu:14.04.2
RUN apt-get update && apt-get install --no-install-recommends -y python-minimal busybox && rm -rf /var/lib/apt/lists/*;
ADD https://bootstrap.pypa.io/get-pip.py /usr/bin/
RUN python /usr/bin/get-pip.py
RUN pip install --no-cache-dir docker-py

ENV VNC noVNC-0.0.2
ENV RANCHER_HOME /var/lib/rancher

COPY self.pem $RANCHER_HOME/

ADD $VNC.tar.gz $RANCHER_HOME/
COPY css/rancherVM.css $RANCHER_HOME/$VNC/css/
COPY ranchervm_logo.png $RANCHER_HOME/$VNC/images/
COPY index.html $RANCHER_HOME/$VNC/
COPY ranchervm $RANCHER_HOME/$VNC/cgi-bin/
COPY startmgmt $RANCHER_HOME/

ENTRYPOINT ["/var/lib/rancher/startmgmt"]
VOLUME /ranchervm
CMD []
