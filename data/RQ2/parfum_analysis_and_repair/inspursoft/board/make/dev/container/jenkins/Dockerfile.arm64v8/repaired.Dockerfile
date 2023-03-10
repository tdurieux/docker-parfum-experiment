FROM inspursoft/jenkins-arm64v8:8-jdk-stretch

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false \
               -Dhudson.model.User.allowNonExistentUser=true"
USER root

COPY make/dev/container/jenkins/jobs /tmp/jobs

RUN wget https://files.pythonhosted.org/packages/09/1c/72bc7d3e1964633b29c9013813e3c0da0f6ae15c901ddc3863e2c54e87f7/python-jenkins-0.4.15.tar.gz \
    -P /usr/share/jenkins
RUN wget https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz \
    -P /usr/share/jenkins 
RUN wget https://files.pythonhosted.org/packages/6c/54/f7e9cea6897636a04e74c3954f0d8335cc38f7d01e27eec98026b049a300/setuptools-38.5.1.zip \
    -P /usr/share/jenkins

COPY make/dev/container/jenkins/pythonenv.sh /usr/share/jenkins/pythonenv.sh
COPY make/dev/container/jenkins/plugins.txt /usr/share/jenkins/plugins.txt
COPY make/dev/container/jenkins/addNode.py /usr/share/jenkins/addNode.py
COPY make/dev/container/jenkins/jenkins.sh /usr/local/bin/jenkins.sh
COPY make/dev/container/jenkins/init.sh /usr/share/jenkins/init.sh

ENV JENKINS_UC_DOWNLOAD=https://mirrors.tuna.tsinghua.edu.cn/jenkins

RUN  sed -i 's/^root\:x\:0\:/root\:x\:0\:root\,jenkins/' /etc/group \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
      && chmod u+x /usr/share/jenkins/pythonenv.sh \
      && /usr/share/jenkins/pythonenv.sh \
      && chmod u+x /usr/local/bin/jenkins.sh \
      && chmod u+x /usr/share/jenkins/init.sh \
      && /usr/share/jenkins/pythonenv.sh \
      && /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt