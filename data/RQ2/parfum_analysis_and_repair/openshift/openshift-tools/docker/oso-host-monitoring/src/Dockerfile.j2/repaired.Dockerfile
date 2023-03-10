{% if base_os == "rhel7" %}
FROM oso-rhel7-ops-base:latest
{% elif base_os == "centos7" %}
FROM openshifttools/oso-centos7-ops-base:latest
{% endif %}
{{ generated_header }}

# Pause indefinitely if asked to do so.
ARG OO_PAUSE_ON_BUILD
RUN test "$OO_PAUSE_ON_BUILD" = "true" && while sleep 10; do true; done || :

# denote this as a container environment, for rc scripts
ENV PCP_CONTAINER_IMAGE pcp-collector
ENV NAME pcp-collector
ENV IMAGE pcp-collector
ENV PATH /usr/share/pcp/lib:/usr/libexec/pcp/bin:$PATH

# script to watch health of pmcd
COPY check-pmcd-status.sh /usr/local/bin/check-pmcd-status.sh
##################

{% if base_os == "rhel7" %}
# /usr/bin/oc workaround
# python-openshift-tools-monitoring-openshift depends on /usr/bin/oc
# since origin-clients and atomic-openshift-clients provide the binary
# for Origin/OpenShift respectively. yum isn't happy that a package named 'openshift'
# used to provide /usr/bin/oc, and 'openshift' has been replaced by
# 'atomic-openshift', but 'atomic-openshift' doesn't provide /usr/bin/oc.
# So just install atomic-openshift-clients before python-openshift-tools-monitoring-openshift
# until the yum repo is cleared of the older packages.
RUN yum-install-check.sh -y atomic-openshift-clients openshift-hypercc && yum clean metadata

{% endif %}


# Add google-cloud-sdk repo
COPY google-cloud-sdk.repo /etc/yum.repos.d/
{% if base_os == "centos7" %}

# Add copr repo for python-hawkular-client rpm
RUN cd /etc/yum.repos.d && curl -f -O https://copr.fedorainfracloud.org/coprs/g/Hawkular/python-hawkular-client/repo/epel-7/group_Hawkular-python-hawkular-client-epel-7.repo
{% endif %}

RUN yum -y install python2-pip python2-requests pcp pcp-conf \
        pyOpenSSL python-openshift-tools \
        python-openshift-tools-monitoring-pcp \
        python-openshift-tools-monitoring-docker \
        python-openshift-tools-monitoring-zagg \
        python-openshift-tools-monitoring-openshift \
        python-openshift-tools-ansible \
        python-openshift-tools-web \
        openshift-tools-scripts-cloud-aws \
        openshift-tools-scripts-cloud-gcp \
        openshift-tools-scripts-monitoring-pcp \
        openshift-tools-scripts-monitoring-docker \
        openshift-tools-scripts-monitoring-aws \
        openshift-tools-scripts-monitoring-gcp \
        openshift-tools-scripts-monitoring-openshift \
        openshift-tools-scripts-monitoring-autoheal \
        python-httplib2 \
        python2-pyasn1 python2-pyasn1-modules python2-rsa \
        python-configobj \
        python2-psutil \
        pylint \
        tito \
        python-devel \
        libyaml-devel \
        oso-simplesamlphp \
        python2-ruamel-yaml \
        rpm-sign \
        createrepo \
        python2-boto3 \
        python-lxml \
        rkhunter \
        python-hawkular-client \
        python-docker pcp-manager pcp-webapi\
        python-pcp patch && yum clean all && rm -rf /var/cache/yum

# Run in the container as root - avoids PCP_USER mismatches
RUN sed -i -e 's/PCP_USER=.*$/PCP_USER=root/' -e 's/PCP_GROUP=.*$/PCP_GROUP=root/' /etc/pcp.conf

# Disable service advertising - no avahi daemon in the container
# (dodges warnings from pmcd attempting to connect during startup)
RUN . /etc/pcp.conf && echo "-A" >> $PCP_PMCDOPTIONS_PATH

{# This is installed for gsutil and calculating the size of the gcs #}
{# centos users should install this from https://cloud.google.com/sdk/downloads and follow the instructions #}
{# disabling releases-optional repo as the filelist_db metadata file is over 1GB #}
{% if base_os == 'rhel7' %}
RUN yum-install-check.sh -y google-cloud-sdk python2-uritemplate python2-google-api-client python2-oauth2client --disablerepo="rhel-server-releases-optional" --enablerepo="google-cloud-sdk" && yum clean all
{% endif %}


COPY urllib3-connectionpool-patch /root/
RUN cd /usr/lib/python2.7/site-packages/ && patch -p1 < /root/urllib3-connectionpool-patch

# make mount points for security update count check, and make a circular symlink because yum is dumb about its root
RUN mkdir -p /host \
             /var/local/hostpkg/etc/rhsm/ca \
             /var/local/hostpkg/etc/rpm \
             /var/local/hostpkg/etc/pki/entitlement \
             /var/local/hostpkg/etc/pki/rpm-gpg \
             /var/local/hostpkg/var/local \
             /var/local/hostpkg/var/cache/yum \
             /var/local/hostpkg/var/lib/yum && \
    ln -s /var/local/hostpkg /var/local/hostpkg/var/local/hostpkg

# Make mount points for rkhunter files, and configure rkhunter to work with this structure
RUN mkdir -p /var/local/rkhunter_chroot \
             /var/local/rkhunter_tmp \
             /var/local/rkhunter_tmp/rkhunter \
             /var/local/rkhunter_tmp/rkhunter/bin \
             /var/local/rkhunter_tmp/rkhunter/db \
             /var/local/rkhunter_tmp/rkhunter/etc \
             /var/local/rkhunter_tmp/rkhunter/scripts && \
    sed -i 's/\/var\/log\/rkhunter\/rkhunter.log/\/var\/local\/rkhunter_tmp\/rkhunter\/rkhunter.log/' /etc/logrotate.d/rkhunter && \
    sed -r -e 's%^(SCRIPTDIR)=.*%\1=/tmp/rkhunter/scripts%; s%^(LOGFILE)=.*%\1=/tmp/rkhunter/rkhunter.log%' /etc/rkhunter.conf > /var/local/rkhunter_tmp/rkhunter/etc/rkhunter.conf

# Ansible startup configuration playbook
COPY root /root

RUN cat bash_aliases >> /root/.bashrc

# FIXME: These are vendor libs that need to be packaged and installed via RPM.
COPY vendor/prometheus_client /usr/lib/python2.7/site-packages/prometheus_client/

# Create ops-runner.log file with proper permissions
RUN touch /var/log/ops-runner.log && chmod 664 /var/log/ops-runner.log

# Setup the AWS credentials file so that we can populate it on startup.
RUN mkdir -p /root/.aws && \
    touch /root/.aws/credentials && \
    chmod g+rw /root/.aws/credentials

# Add container-build-env-fingerprint
COPY container-build-env-fingerprint.output /etc/oso-container-build-env-fingerprint

# Add the start script and tell the container to run it by default
COPY start.sh /usr/local/bin/
CMD /usr/local/bin/start.sh
