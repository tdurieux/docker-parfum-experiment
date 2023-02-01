FROM centos:6

# xterm dependency is an extra to get the casa shell in the display
# perl was added for casa later than 5

# Override old repo info with current urls
RUN rm /etc/yum.repos.d/CentOS-Base.repo
ADD CentOS-Base.repo /etc/yum.repos.d/

RUN yum clean all -y
RUN yum makecache -y
RUN yum update -y
RUN yum install -y freetype libSM libXi libXrender libXrandr \
	libXfixes libXcursor libXinerama fontconfig \
        libxslt xauth xorg-x11-server-Xvfb dbus-x11 \
	tkinter ImageMagick-c++ xterm perl autoconf python-sphinx graphviz xz

# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

# unpack and move casa databundle to container
ADD ${CASA_RELEASE}.tar.xz /opt/

# ADD does not untar xz automatically
# RUN unxz /opt/${CASA_RELEASE}.tar.xz
# RUN tar -xf /opt/${CASA_RELEASE}.tar

# chown because the untarred casa has wrong owner/group
RUN chown -R root:root /opt/${CASA_RELEASE%%-py*} && ln -s /opt/${CASA_RELEASE%%-py*} /opt/casa

RUN yum install -y sssd-client acl

# add the admit enhancement (issue #25)
RUN yum install -y tcsh
RUN mkdir /opt/admit
ADD admit /opt/admit
RUN cd /opt/admit && \
    autoconf && ./configure --with-casa-root=/opt/${CASA_RELEASE%%-py*}

# Allow runtime symlink creation to the casa-data-repository
RUN rm -rf /opt/${CASA_RELEASE%%-py*}/data
RUN chmod 777 /opt/${CASA_RELEASE%%-py*}

RUN mkdir /skaha
ADD init.sh /skaha/

# generate missing dbus uuid (issue #47)
RUN dbus-uuidgen --ensure

ADD nsswitch.conf /etc/

CMD [ "/skaha/init.sh" ]
