# This image provides a Python 3.3 environment you can use to run your Python
# applications.
FROM openshift3/sti-base:1.0

EXPOSE 8080

ENV PYTHON_VERSION=3.3 \
    PATH=$HOME/.local/bin/:$PATH

LABEL io.k8s.description="Platform for building and running Python 3.3 applications" \
      io.k8s.display-name="Python 3.3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,python,python33" \
      BZComponent="openshift-sti-python-docker" \
      Name="openshift3/python-33-rhel7" \
      Version="3.3" \
      Release="34" \
      Architecture="x86_64"

RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum-config-manager --enable rhel-7-server-ose-3.2-rpms && \
    yum-config-manager --disable epel >/dev/null || : && \
    INSTALL_PKGS="python33 python33-python-devel python33-python-setuptools python33-python-pip nss_wrapper httpd httpd-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove redhat-logos (httpd dependency) to keep image size smaller.
    rpm -e --nodeps redhat-logos && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container under
# random UID.
RUN chown -R 1001:0 /opt/app-root && chmod -R og+rwx /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage
