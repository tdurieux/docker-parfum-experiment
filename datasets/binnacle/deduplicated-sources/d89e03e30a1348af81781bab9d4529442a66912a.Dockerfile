FROM centos:7.6.1810

ARG PACKAGE_NAME
ARG PACKAGE_VERSION

# install prerequisites
RUN yum -y update
RUN yum install -y yum-utils device-mapper-persistent-data lvm2

# setting external repositories
ADD *.repo /etc/yum.repos.d/
RUN yum -y install epel-release
RUN yum -y update

# download required rpm files
WORKDIR /out

# determine version of package and download
RUN SEARCHED_PACKAGE=$(repoquery "$PACKAGE_NAME-*:$PACKAGE_VERSION*" | grep "$PACKAGE_NAME-[0-9]\{1,3\}:$PACKAGE_VERSION*") \
&& echo $SEARCHED_PACKAGE \
&& yumdownloader $SEARCHED_PACKAGE
#
