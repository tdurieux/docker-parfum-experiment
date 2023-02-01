# Ansible (gewo/ansible)
FROM gewo/python
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

RUN apt-get update && \
  apt-get install --no-install-recommends -y libyaml-dev libgmp-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir ansible
CMD ["/bin/bash"]
