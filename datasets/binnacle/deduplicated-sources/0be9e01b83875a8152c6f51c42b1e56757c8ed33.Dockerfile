FROM ubuntu
MAINTAINER Thomas Uhrig (tuhrig@informatica.com)

RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN apt-get update && apt-get -y install python-software-properties wget curl
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java8-installer && apt-get clean
RUN update-alternatives --display java
RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment
RUN echo '# /lib/init/fstab: cleared out for bare-bones lxc' > /lib/init/fstab
RUN ln -sf /proc/self/mounts /etc/mtab

ADD /Deploy-Man-Web.jar /opt/deployman/DM.jar
ADD /title.txt /opt/deployman/title.txt
ADD /deployman.properties /opt/deployman/deployman.properties
ADD /static /opt/deployman/static

EXPOSE 4567

CMD cd /opt/deployman/ && java -jar ./DM.jar