FROM rhel7
# This image provides a .NET Core 1.0 environment you can use to run your .NET
# applications.

EXPOSE 8080

ENV DOTNET_CORE_VERSION=1.0
ENV HOME=/opt/app-root \
    PATH=/opt/app-root/src/.local/bin:/opt/app-root/src/bin:/opt/app-root/bin:/opt/app-root/node_modules/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    DOTNET_PUBLISH_PATH=/opt/app-root/publish \
    DOTNET_RUN_SCRIPT=/opt/app-root/publish/s2i_run

LABEL io.k8s.description="Platform for building and running .NET Core 1.0 applications" \
      io.k8s.display-name=".NET Core 1.0" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.openshift.tags="builder,.net,dotnet,dotnetcore,rh-dotnetcore10" \
      io.openshift.expose-services="8080:http" \
      io.s2i.scripts-url=image:///usr/libexec/s2i

# Labels consumed by Red Hat build service
LABEL name="dotnet/dotnetcore-10-rhel7" \
      com.redhat.component="rh-dotnetcore10-container" \
      version="1.0" \
      release="47" \
      architecture="x86_64"

COPY ./root/usr/bin /usr/bin

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ /usr/libexec/s2i

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

RUN INSTALL_PKGS="rh-dotnetcore10 nss_wrapper tar rh-nodejs4-npm" && \
    yum install -y --setopt=tsflags=nodocs --disablerepo=\* \
      --enablerepo=rhel-7-server-rpms,rhel-server-rhscl-7-rpms,rhel-7-server-dotnet-rpms \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
# trim nodejs dependencies to reduce image size and to avoid rebuilds on kernel CVEs.
    rpm -e --nodeps glibc-headers glibc-devel gcc gcc-c++ kernel-headers && \
    yum clean all -y && \
# yum cache files may still exist (and quite large in size)
    rm -rf /var/cache/yum/* && \
    mkdir -p /opt/app-root/src /opt/app-root/publish && \
    useradd -u 1001 -r -g 0 -d /opt/app-root/src -s /sbin/nologin \
      -c "Default Application User" default && \
    chown -R 1001:0 /opt/app-root

# Switch to default app-user for cache population
USER 1001

# Don't download/extract docs for nuget packages
ENV NUGET_XMLDOC_MODE=skip

# - Initialize the .Net cache via 'scl enable rh-dotnetcore10 -- dotnet new'
#   Move to the proper command to do this once https://github.com/dotnet/cli/issues/3692 is fixed.
# - Removal of /tmp/NuGetScratch is needed due to:
#   https://github.com/NuGet/Home/issues/2793
RUN cd /opt/app-root/src && mkdir cache-warmup && \
    cd cache-warmup && \
    scl enable rh-dotnetcore10 -- dotnet new && \
    cd .. && \
    rm -rf cache-warmup && \
    rm -rf /tmp/NuGetScratch

# Switch back to root for changing dir ownership/permissions
USER 0

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container under
# random UID.
RUN chown -R 1001:0 /opt/app-root && chmod -R og+rwx /opt/app-root

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/opt/app-root \
    ENABLED_COLLECTIONS="rh-dotnetcore10 rh-nodejs4"

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/etc/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/etc/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/etc/scl_enable"

# Directory with the sources is set as the working directory. This should
# be a folder outside $HOME as this might cause issues when compiling sources.
# See https://github.com/redhat-developer/s2i-dotnetcore/issues/28
WORKDIR /opt/app-root/src

# Run container by default as user with id 1001 (default)
USER 1001

# By default, ASP.NET Core runs on port 5000. We configure it to match
# the container port.
ENV ASPNETCORE_URLS=http://*:8080

ENTRYPOINT ["container-entrypoint"]

# Set the default CMD to print the usage of the language image.
CMD /usr/libexec/s2i/usage