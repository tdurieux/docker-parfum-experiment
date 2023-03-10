ARG  os_image
FROM ${os_image}
ARG  log_output_dir=/tmp
ENV  LOG_OUTPUT_DIR="$log_output_dir"
ARG  py_N
ENV  PY_N "$py_N"

RUN  apt update
RUN apt install --no-install-recommends -y git netcat-openbsd sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python${py_N} python${py_N}-pip && rm -rf /var/lib/apt/lists/*;
RUN  useradd -md /home/user -s /bin/bash user
RUN  echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/user
COPY ./ ./repo/
RUN chown -R user repo/
USER user
RUN pip${py_N} install --no-cache-dir --user --upgrade pip==20.3.4# -- version specified for Ub16
RUN  cd repo && python${py_N} -m pip install --user '.[tests]'
RUN  python${py_N} repo/docker_build/iinit.py \
        host irods-provider \
        port 1247     \
        user rods     \
        zone tempZone \
        password rods

SHELL ["/bin/bash","-c"]

# -- At runtime: --
#  1. wait for provider to run.
#  2. give user group permissions to access shared irods directories
#  3. run python tests as the new group

CMD  echo "Waiting on iRODS server... " ; \
     python${PY_N} repo/docker_build/recv_oneshot -h irods-provider -p 8888 -t 360 && \
     sudo groupadd -o -g $(stat -c%g /irods_shared) irods && sudo usermod -aG irods user && \
     newgrp irods < repo/run_python_tests.sh
