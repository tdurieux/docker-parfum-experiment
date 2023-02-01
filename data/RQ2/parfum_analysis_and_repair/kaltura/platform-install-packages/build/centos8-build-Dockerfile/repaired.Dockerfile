FROM centos:8

ENV BUILD_USER
ENV GITHUB_USER
ENV PACKAGER_NAME ""
ENV PACKAGER_MAIL

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
RUN dnf install epel-release -y
RUN yum install -y gcc gcc-c++ \
                   libtool libtool-ltdl \
                   make cmake \
                   git \
                   pkgconfig \
                   sudo \
                   automake autoconf \
                   yum-utils rpm-build && \
                   wget which && \
    yum clean all && rm -rf /var/cache/yum

RUN useradd $BUILD_USER --home /home/$BUILD_USER --shell /bin/bash && \
    echo "$BUILD_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chown -R $BUILD_USER /home/$BUILD_USER
RUN mkdir /home/$BUILD_USER/sources /home/$BUILD_USER/rpmbuild
RUN cd /home/$BUILD_USER/sources && git clone https://$GITHUB_USER@github.com/kaltura/platform-install-packages
RUN echo "PACKAGER_NAME=\"$PACKAGER_NAME\"\nPACKAGER_MAIL=$PACKAGER_MAIL" > /home/$BUILD_USER/sources/platform-install-packages/build/packager.rc
RUN cp /root/.bashrc /home/$BUILD_USER
RUN echo -e "DEBFULLNAME=\"$PACKAGER_NAME\"\nDEBEMAIL=$PACKAGER_MAIL\nexport DEBEMAIL DEBFULLNAME" >> /home/$BUILD_USER/.bashrc
RUN ln -s /home/$BUILD_USER/sources/platform-install-packages/SOURCES /home/$BUILD_USER/rpmbuild/SOURCES
RUN ln -s /home/$BUILD_USER/sources/platform-install-packages/SPECS /home/$BUILD_USER/rpmbuild/SPECS
RUN chown -R $BUILD_USER.$BUILD_USER /home/$BUILD_USER
USER $BUILD_USER

ENV FLAVOR=rpmbuild OS=centos DIST=el8
