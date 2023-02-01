FROM jenkins/jenkins:2.89.3

USER root

# do not rely on installed maven package, which is generally too old
ENV MAVEN_VERSION 3.5.2
RUN cd /usr/local; wget -q -O - http://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvfz - && \
    ln -sv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

# install Jetty
WORKDIR /opt
# jetty package is still 8
ENV JETTY_VERSION 9.3.9.v20160517
RUN wget -q -O - "http://archive.eclipse.org/jetty/$JETTY_VERSION/dist/jetty-distribution-$JETTY_VERSION.tar.gz" | tar xvfz - && \
    ln -sv jetty-distribution-$JETTY_VERSION jetty && \
    (cd /tmp; ln -s /opt/jetty/webapps) && \
    chown -R jenkins /opt/jetty/logs && \
    chown -R jenkins /opt/jetty/webapps

RUN apt-get update && \
    apt-get install -y patch

WORKDIR /tmp/files

COPY plugins /usr/share/jenkins/ref/plugins
RUN chown -R jenkins.jenkins /usr/share/jenkins/ref/plugins
USER jenkins

ADD repo repo
ADD repo-branches repo-branches
ADD lib lib
ADD globallib globallib
USER root
RUN chown -R jenkins.jenkins repo lib globallib
USER jenkins
RUN for r in repo lib globallib; do \
      (cd $r && \
       git init && \
       git add . && \
       git -c user.email=demo@jenkins-ci.org -c user.name="Pipeline Demo" commit -m 'demo' && \
       (echo '[receive]'; echo '    denyCurrentBranch = ignore') >> .git/config); \
    done; \
    for patch in `pwd`/repo-branches/*.diff; do \
      branch=`basename -s .diff $patch` && \
      (cd repo && \
       git checkout -b $branch master && \
       patch -p0 < $patch && \
       git -c user.email=demo@jenkins-ci.org -c user.name="Pipeline Demo" commit -a -m $branch); \
    done

ADD JENKINS_HOME /usr/share/jenkins/ref

USER root
RUN chown -R jenkins.jenkins /usr/share/jenkins/ref
COPY run.sh jetty.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/run.sh /usr/local/bin/jetty.sh

USER jenkins
CMD /usr/local/bin/run.sh

EXPOSE 8080 8081 9418
