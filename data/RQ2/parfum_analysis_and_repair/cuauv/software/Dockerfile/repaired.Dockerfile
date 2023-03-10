FROM cuauv/phusion-baseimage:0.11
CMD ["/sbin/my_init"]
RUN rm -f /etc/service/sshd/down && \
    sed -i'' 's/http:\/\/archive.ubuntu.com/http:\/\/us.archive.ubuntu.com/' /etc/apt/sources.list && \
    sed -i'' 's/http:\/\/ports.ubuntu.com/http:\/\/us.ports.ubuntu.com/' /etc/apt/sources.list

RUN mkdir /dependencies && chmod -R 755 /dependencies

COPY install/aptstrap.sh /dependencies/

COPY install/foundation-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/foundation-install.sh

COPY install/python-latest-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/python-latest-install.sh

COPY install/python-latest-pip-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/python-latest-pip-install.sh

COPY install/jetson-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/jetson-install.sh

COPY install/opencv-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/opencv-install.sh

# We don't currently use caffe and build is failing with Python 3.8.
#COPY install/caffe-install.sh /dependencies/
#RUN bash /dependencies/aptstrap.sh /dependencies/caffe-install.sh

COPY install/setup-user.sh /dependencies/
COPY install/ssh /dependencies/ssh
RUN bash /dependencies/setup-user.sh

COPY install/ocaml-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/ocaml-install.sh
COPY install/ocaml-user-install.sh /dependencies/
RUN setuser software /dependencies/ocaml-user-install.sh

COPY install/node-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/node-install.sh

# Spacemacs install is breaking for some reason, but we don't need it anyway
#COPY install/spacemacs-install.sh /dependencies/
#RUN bash /dependencies/aptstrap.sh /dependencies/spacemacs-install.sh
#COPY install/dot-spacemacs /dependencies/
#RUN setuser software cp /dependencies/dot-spacemacs /home/software/.spacemacs && \
#    setuser software emacs --batch -u software --kill

COPY install/ripgrep-install.sh /dependencies
RUN /dependencies/ripgrep-install.sh

COPY install/apt-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/apt-install.sh

COPY install/pip-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/pip-install.sh

COPY install/misc-install.sh /dependencies/
RUN bash /dependencies/aptstrap.sh /dependencies/misc-install.sh

COPY install/runit /dependencies/runit
RUN cp -r /dependencies/runit/* /etc/service/

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/ /dependencies/

USER software
WORKDIR /home/software/cuauv/software
CMD echo "CUAUV Docker container should be started through a wrapping tool (cdw or docker-helper.sh"