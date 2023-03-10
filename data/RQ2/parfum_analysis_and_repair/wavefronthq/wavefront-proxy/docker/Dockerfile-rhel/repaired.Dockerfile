# NOTE: we need this to be a Dockerfile because that's the only option
# when using the Automated Build Service for Red Hat Build Partners.
# see: https://connect.redhat.com/en/blog/automated-build-service-red-hat-build-partners

FROM registry.access.redhat.com/ubi7

MAINTAINER wavefront@vmware.com

LABEL name="Wavefront Collector" \
    vendor="Wavefront by VMware" \
    version="10.13" \
    release="10.13" \
    summary="The Wavefront Proxy is a light-weight Java application that you send your metrics, histograms, and trace data to. It handles batching and transmission of your data to the Wavefront service in a secure, fast, and reliable manner." \
    description="The Wavefront Proxy is a light-weight Java application that you send your metrics, histograms, and trace data to. It handles batching and transmission of your data to the Wavefront service in a secure, fast, and reliable manner."

RUN mkdir /licenses

COPY LICENSE /licenses
COPY ./proxy/docker/run.sh run.sh

EXPOSE 3878
EXPOSE 2878
EXPOSE 4242

# This script may automatically configure wavefront without prompting, based on
# these variables:
#  WAVEFRONT_URL           (required)
#  WAVEFRONT_TOKEN         (required)
#  JAVA_HEAP_USAGE         (default is 4G)
#  WAVEFRONT_HOSTNAME      (default is the docker containers hostname)
#  WAVEFRONT_PROXY_ARGS    (default is none)
#  JAVA_ARGS               (default is none)

RUN yum-config-manager --enable rhel-7-server-optional-rpms \
    && yum update --disableplugin=subscription-manager -y \
    && rm -rf /var/cache/yum \
    && yum install -y sudo curl hostname java-11-openjdk-devel && rm -rf /var/cache/yum

# Add new group:user "wavefront"
RUN /usr/sbin/groupadd -g 2000 wavefront && useradd --comment '' --uid 1000 --gid 2000 wavefront
RUN chown -R wavefront:wavefront /var
RUN chown -R wavefront:wavefront /usr/lib/jvm/java-11-openjdk/lib/security/cacerts
RUN chmod 755 /var

# Download wavefront proxy (latest release). Merely extract the package, don't want to try running startup scripts.
RUN curl -f -s https://packagecloud.io/install/repositories/wavefront/proxy/script.rpm.sh | sudo bash \
    && yum -y update \
    && yum -y -q install wavefront-proxy && rm -rf /var/cache/yum

# Configure agent
RUN cp /etc/wavefront/wavefront-proxy/log4j2-stdout.xml.default /etc/wavefront/wavefront-proxy/log4j2.xml

# Run the agent
USER 1000:2000
CMD ["/bin/bash", "/run.sh"]
