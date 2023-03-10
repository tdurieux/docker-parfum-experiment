ARG  os_image
FROM ${os_image}
ARG  log_output_dir=/tmp
ENV  LOG_OUTPUT_DIR="$log_output_dir"
ARG  py_N
ENV  PY_N "$py_N"

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y git nmap-ncat sudo && rm -rf /var/cache/yum
RUN yum install -y python${py_N} python${py_N}-pip && rm -rf /var/cache/yum
RUN  useradd -md /home/user -s /bin/bash user
RUN  echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/user
COPY ./ ./repo/
RUN chown -R user repo/
USER user
RUN pip${py_N} install --no-cache-dir --user --upgrade pip==20.3.4# - limit pip version for C7 system python2.7
RUN  cd repo && python${py_N} -m pip install --user '.[tests]'
RUN  python${py_N} repo/docker_build/iinit.py \
        host irods-provider \
        port 1247     \
        user rods     \
        zone tempZone \
        password rods
SHELL ["/bin/bash","-c"]
CMD  echo "Waiting on iRODS server... " ; \
     python${PY_N} repo/docker_build/recv_oneshot -h irods-provider -p 8888 -t 360 && \
     sudo groupadd -o -g $(stat -c%g /irods_shared) irods && sudo usermod -aG irods user && \
     newgrp irods < repo/run_python_tests.sh
