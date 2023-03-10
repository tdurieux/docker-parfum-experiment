# This is an intermediate image
FROM registry.redhat.io/rhel8/python-38 as base

COPY version/VERSION /exporter/
COPY exporter.py /exporter/
COPY metrics.json /exporter/

# Using Red Hat Universal Base Image 8 
# This is final shipping image
FROM registry.redhat.io/ubi8

ARG VER
### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Citrix ADC Metric Exporter" \
      maintainer="NSCPXOrchestration@citrite.net" \
      vendor="Citrix" \
      version=${VER} \
      summary="Citrix provides an metrics exporter for Citrix ADC MPX (hardware), Citrix ADC VPX (virtualized), Citrix ADC CPX (containerized) and Citrix ADC BLX (Bare Metal) for on-prem and cloud deployments. It is is a simple server that scrapes Citrix ADC stats and exports them via HTTP to Prometheus." \
      description="Citrix provides an metrics exporter for Citrix ADC MPX (hardware), Citrix ADC VPX (virtualized), Citrix ADC CPX (containerized) and Citrix ADC BLX (Bare Metal) for on-prem and cloud deployments. It is is a simple server that scrapes Citrix ADC stats and exports them via HTTP to Prometheus."

#### add licenses to this directory
COPY license/LICENSE /licenses/

# Make bash the default shell
SHELL ["/bin/bash", "-c"]

# RHEL 8 requires a subscription. Use --build-arg USERNAME=<RHEL_USERNAME> --build-arg PASSWORD=<RHEL_PASSWORD> for these arguments.
ARG USERNAME
ARG PASSWORD
RUN subscription-manager register --username ${USERNAME} --password ${PASSWORD} --auto-attach

RUN yum -y update \
    && yum -y install python38 \
    && alternatives --set python /usr/bin/python3 \
    && dnf install -y python3-pip \
    && yum clean all && rm -rf /var/cache/yum

# Removing subscription from image as private RHEL credential was used for the subscription.
RUN subscription-manager unregister
COPY --from=base /opt/app-root/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/
COPY --from=base /usr/lib64/libpython* /usr/local/lib/
COPY --from=base /exporter /exporter/
RUN touch /exporter/exporter.log
RUN ln -sf /dev/stdout /exporter/exporter.log
COPY ./pip_requirements.txt .
RUN python3.8 -m pip install -r pip_requirements.txt

# Starting CIC as nobody
USER nobody

ENTRYPOINT ["python3.8", "/exporter/exporter.py"]
