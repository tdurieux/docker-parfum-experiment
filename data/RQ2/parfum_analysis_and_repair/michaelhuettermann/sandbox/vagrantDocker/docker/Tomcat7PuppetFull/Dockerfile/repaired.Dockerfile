FROM ubuntu:14.04
MAINTAINER Michael Huettermann
# Update Ubuntu
RUN apt-get update && apt-get -y upgrade
# Add oracle java 7 repository
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
# Accept the Oracle Java license
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
# Install Oracle Java
RUN apt-get -y --no-install-recommends install oracle-java7-installer && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install puppet librarian-puppet && rm -rf /var/lib/apt/lists/*;

RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-tomcat

ADD site.pp /root/site.pp
RUN chmod +x /root/site.pp
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

EXPOSE 8080

CMD ["/root/run.sh"]


