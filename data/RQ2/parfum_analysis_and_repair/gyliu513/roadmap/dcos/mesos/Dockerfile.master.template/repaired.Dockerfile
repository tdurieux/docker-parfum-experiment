MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>

RUN mkdir -p /opt/work /opt/log

ENTRYPOINT ["mesos-master", "--work_dir=/opt/work", "--log_dir=/opt/log"]