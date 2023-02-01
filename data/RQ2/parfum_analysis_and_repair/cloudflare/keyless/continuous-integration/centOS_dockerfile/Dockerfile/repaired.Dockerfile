#Set the base image to centOS
FROM centos
RUN yum install -y gcc automake libtool && rm -rf /var/cache/yum
RUN yum install -y openssh-clients && rm -rf /var/cache/yum
RUN yum install -y git wget zip unzip tar && rm -rf /var/cache/yum
RUN yum install -y ruby && rm -rf /var/cache/yum
RUN yum install -y ruby-devel && rm -rf /var/cache/yum
RUN yum install -y rubygems && rm -rf /var/cache/yum
RUN yum install -y rpm-build && rm -rf /var/cache/yum
RUN gem install -y fpm
RUN mkdir /root/.ssh/

#copy over private key and set permissions
ADD remote-agent /root/.ssh/remote-agent
RUN chmod 600 /root/.ssh/remote-agent

#create known hosts
RUN touch /root/.ssh/known_hosts
#add key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
