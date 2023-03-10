MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>
MAINTAINER Yong Feng <yongfeng@ca.ibm.com>

RUN mkdir -p /opt/ibm/mesos/work /opt/ibm/mesos/log

# Install docker util into docker image
#RUN apt-get -y install apt-transport-https
#RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
#RUN apt-get update && apt-get purge lxc-docker* && apt-cache policy docker-engine
#RUN apt-get -y install docker-engine

# install iptables for k8s
RUN apt-get -y --no-install-recommends install iptables && rm -rf /var/lib/apt/lists/*;

# install nsenter for k8s, nsenter is not included in util-linux in Ubuntu14.04
COPY ./nsenter /usr/bin/

# copy docker binaries from build machine
COPY ./docker /usr/bin/

USER root

ENTRYPOINT ["mesos-slave", "--containerizers=docker,mesos", "--docker_socket=/var/run/docker.sock", "--work_dir=/opt/ibm/mesos/work", "--log_dir=/opt/ibm/mesos/log"]
