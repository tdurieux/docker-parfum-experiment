#-----------------------------------------------------------------------
# Control-M/Agent in a docker container in user-defined network
# The docker host is an AWS Linux machine
#-----------------------------------------------------------------------

FROM centos:7
MAINTAINER Joe Goldberg <joe_goldberg@bmc.com>

ARG CTMHOST
ARG CTMENV

# install basic packages
RUN yum -y update \
	&& yum -y install wget \
	&& yum -y install unzip \
	&& yum -y install sudo \
	&& yum -y install net-tools \
	&& yum -y install psmisc && rm -rf /var/cache/yum

# install nodejs
RUN curl -f --silent --location https://rpm.nodesource.com/setup_6.x | bash - \
	&& yum -y install nodejs \
	&& node -v \
	&& npm -v && rm -rf /var/cache/yum

# install java 8
RUN yum -y install java-1.8.0-openjdk \
	&& java -version && rm -rf /var/cache/yum

# install ctm-automation-api kit
WORKDIR /root
RUN mkdir ctm-automation-api \
	&& cd ctm-automation-api \
	&& wget --no-check-certificate https://$CTMHOST:8443/automation-api/ctm-cli.tgz \
	&& npm install -g ctm-cli.tgz \
	&& ctm -v && npm cache clean --force;

# add ec2-user user and root to soduers list
RUN useradd -d /home/ec2-user -p ec2-user -m ec2-user \
	&& echo 'root ALL=(ALL) ALL' >> /etc/sudoers \
	&& echo 'ec2-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Extract Control-M Environment definition for the specified CTMENV
# and add to current user
USER ec2-user
WORKDIR /home/ec2-user

# Copy secrets from Docker build context - If running in a Swarm, use Docker secrets management or any desired vault
# and create a default environment with the secret info
RUN mkdir /tmp/.ctm
COPY $CTMENV/*.secret /home/ec2-user/
RUN ctm env add myctm `cat endpoint.secret` `cat username.secret` `cat password.secret`
RUN ctm env set myctm

# provision controlm agent image
RUN cd \
	&& ctm provision image Agent.Linux

# enable controlm agent utilities
RUN echo "source /home/ec2-user/.bash_profile" >> /home/ec2-user/.bashrc

# copy run and register Control-M agent script to container
COPY run_register_controlm.sh /tmp
COPY decommission_controlm.sh /tmp
RUN cp /tmp/run_register_controlm.sh /home/ec2-user \
	&& cp /tmp/decommission_controlm.sh /home/ec2-user \
	&& chmod +x run_register_controlm.sh \
	&& chmod +x decommission_controlm.sh

# copy sample job flow to container
COPY MultiContainerSampleFlow.json /home/ec2-user/

EXPOSE 7000-8000
EXPOSE 22

CMD ["/home/ec2-user/run_register_controlm.sh"]
