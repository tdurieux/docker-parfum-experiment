FROM jenkins/jenkins:lts
MAINTAINER pawan uppadey <pawan.uppadey@gmail.com>

#Install Jenkins plugin to make this pipeline work
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

#Copy script to auto create user to jenkins init folder
COPY setupJenkins.groovy /usr/share/jenkins/ref/init.groovy.d/

#setup the docker container for scanners
USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
	python-pip \
	curl \
	maven \
	git \
	perl \
	wget \
	kbtin \
	libnet-ssleay-perl \
	software-properties-common && rm -rf /var/lib/apt/lists/*;

#add public key for the multiverse repo which has nikto
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic multiverse'
RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic-security multiverse'
RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic-updates multiverse'

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y nikto && rm -rf /var/lib/apt/lists/*;

#Install virtualenv to isolate each project dependencies
RUN pip install --no-cache-dir virtualenv
#Install python SCA tool/dependency checker, license check
RUN pip install --no-cache-dir safety
RUN pip install --no-cache-dir liccheck
#Install the git history checker for secrets
RUN pip install --no-cache-dir trufflehog
#Install python SAST tool
RUN pip install --no-cache-dir bandit

# Used for authenticated DAST scan
RUN pip install --no-cache-dir selenium

#install the orchestration tool, boto for ec2 module, some lib upgrade under requests
RUN pip install --no-cache-dir ansible
RUN pip install --no-cache-dir boto
RUN pip install --no-cache-dir boto3

# configure ansible to use right keys and not check host auth for this ephemeral/temp aws host
# Not authenticating existing/long-term hosts requiring relogins may lead to mitm.. be careful
COPY ansible.cfg /etc/ansible/ansible.cfg

# drop back to the regular jenkins user - good practice
USER jenkins
