FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN wget -q -O - https://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq --no-install-recommends install jenkins=`apt-cache madison jenkins | head -1 | cut -d \| -f 2 | tr -d ' '` && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq --no-install-recommends install jenkins-cli && rm -rf /var/lib/apt/lists/*;

USER jenkins
ENV HOME /var/lib/jenkins
WORKDIR /var/lib/jenkins
ADD run_jenkins.sh /var/lib/jenkins/run_jenkins.sh

CMD ["/var/lib/jenkins/run_jenkins.sh"]