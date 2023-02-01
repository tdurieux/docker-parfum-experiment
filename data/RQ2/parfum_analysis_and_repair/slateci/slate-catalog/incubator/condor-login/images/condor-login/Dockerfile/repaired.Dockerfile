FROM opensciencegrid/osg-wn

RUN yum update -y

#RUN yum install -y epel-release

RUN yum install -y openssh-server pwgen supervisor authconfig && rm -rf /var/cache/yum

RUN yum install openssl -y && rm -rf /var/cache/yum

# from Mats
#RUN curl -s -o /etc/yum.repos.d/htcondor-testing-rhel7.repo https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-testing-rhel7.repo \
# && echo "priority=10" >>/etc/yum.repos.d/htcondor-testing-rhel7.repo \
# && rpm --import http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor \
# && yum -y install condor \
# && mkdir -p /etc/condor/passwords.d /etc/condor/tokens.d \
# && yum clean all
RUN yum install -y condor && rm -rf /var/cache/yum

RUN yum -y install osg-flock && rm -rf /var/cache/yum

# ran into a weird problem here

# Copy the Gratia probe into the correct place - FIXME
#RUN cp /etc/gratia/condor/ProbeConfig-flocking /etc/gratia/condor/ProbeConfig

# not sure what this does. can we remove it?
RUN echo > /etc/sysconfig/i18n

RUN yum clean all && rm -rf /tmp/yum*

ADD container-files /

RUN yum install -y openssh-clients \
  libXt \
  tcsh \
  gcc \
  libXpm \
  libXpm-devel \
  unzip && rm -rf /var/cache/yum
#  yum install http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm -y && \
#  yum install HEP_OSlibs -y && \
RUN yum clean all

# not needed for now
#RUN mkdir -p /var/lib/condor/credentials

# Preemptive FIXME
#RUN sed -i 's/EnableProbe="0"/EnableProbe="1"/' /etc/gratia/condor/ProbeConfig

COPY 10-base.conf /etc/condor/config.d/

ADD fetch-crl /etc/cron.d/

ENTRYPOINT ["/config/bootstrap.sh"]
