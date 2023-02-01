FROM centos:6

COPY ./mesos-version /mesos-version

RUN rpm -Uvh http://repos.mesosphere.com/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm && \
  yum install -y mesos-$(cat /mesos-version) && \
  yum install -y java-1.8.0-openjdk-headless && \
  curl -L -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  [ $(sha256sum /usr/bin/jq | cut -f 1 -d ' ') == "c6b3a7d7d3e7b70c6f51b706a3b90bd01833846c54d32ca32f0027f00226ff6d" ] && \
  chmod +x /usr/bin/jq && \
  ln -svT /usr/lib/jvm/java-1.8.0-openjdk-* /docker-java-home && \

  # Install Python, Pip and dcrpm
  yum install -y epel-release git && yum install -y python34 python34-devel gcc gcc-c++ && \
  curl -O https://bootstrap.pypa.io/get-pip.py && /usr/bin/python3.4 get-pip.py && \
  pip3 install git+https://github.com/facebookincubator/dcrpm.git@v0.2.0 &&  \

  # Clean
  yum clean all && dcrpm -v

ENV JAVA_HOME /docker-java-home

ENTRYPOINT ["/sbin/init"]
