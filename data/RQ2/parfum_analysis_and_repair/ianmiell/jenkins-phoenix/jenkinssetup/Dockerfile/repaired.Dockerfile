FROM ubuntu:trusty
RUN apt-get update -y && apt-get install --no-install-recommends -y git python python-pip python-yaml curl socat default-jdk wget telnet && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir setuptools PyYAML python-jenkins ordereddict jenkinsapi
WORKDIR /jenkins_setup
RUN git clone https://git.openstack.org/openstack-infra/jenkins-job-builder
WORKDIR /jenkins_setup/jenkins-job-builder
RUN python setup.py install
ADD . /jenkins_setup
ADD jenkins_jobs.ini /etc/jenkins_jobs/jenkins_jobs.ini
WORKDIR /jenkins_setup
CMD /jenkins_setup/startup.sh
