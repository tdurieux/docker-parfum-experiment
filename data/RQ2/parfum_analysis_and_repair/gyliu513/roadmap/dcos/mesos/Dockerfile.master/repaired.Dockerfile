RUN mkdir -p /opt/ibm/mesos/work /opt/ibm/mesos/log

ENTRYPOINT ["mesos-master", "--roles=k8s,marathon", "--work_dir=/opt/ibm/mesos/work", "--log_dir=/opt/ibm/mesos/log"]