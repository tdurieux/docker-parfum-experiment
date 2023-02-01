FROM openshift/base-rhel7

# This image provides a Perl 5.16 environment you can use to run your Perl applications.
EXPOSE 8080

# Image metadata
ENV PERL_VERSION=5.16 \
    PATH=$PATH:/opt/rh/perl516/root/usr/local/bin

LABEL io.k8s.description="Platform for building and running Perl 5.1.6 applications" \
      io.k8s.display-name="Apache 2.4 with mod_perl/5.1.6" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,perl,perl516"

# Labels consumed by Red Hat build service
LABEL com.redhat.component="openshift-sti-perl-docker" \
      name="openshift3/perl-516-rhel7" \
      version="5.16" \
      release="1" \
      architecture="x86_64"

# TODO: Cleanup cpanp cache after cpanminus is installed?
# To use subscription inside container yum command has to be run first (before yum-config-manager)
# https://access.redhat.com/solutions/1443553
RUN yum repolist > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    INSTALL_PKGS="httpd24 perl516 perl516-mod_perl perl516-perl-CPANPLUS" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    scl enable perl516 -- cpanp 's conf prereqs 1; s save system' && \
    scl enable perl516 -- cpanp 's conf allow_build_interactivity 0; s save system'

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN mkdir -p /opt/app-root/etc/httpd.d && \
    sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf  && \
    chmod -R og+rwx /opt/rh/httpd24/root/var/run/httpd /opt/app-root/etc/httpd.d && \
    chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
