FROM ubuntu:20.04
ENV TZ=Pacific/Honolulu
RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone
RUN apt-get update && apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y squashfs-tools && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libseccomp-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y cryptsetup && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y wget && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y sudo && rm -rf /var/lib/apt/lists/*;
RUN wget https://go.dev/dl/go1.17.3.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz && rm go1.17.3.linux-amd64.tar.gz
RUN useradd --create-home --shell /bin/bash apptainer_builder && adduser apptainer_builder sudo
RUN sed -i -e 's| ALL$| NOPASSWD: ALL|' /etc/sudoers
WORKDIR /home/apptainer_builder
RUN printf "\nexport PATH=$PATH:/usr/local/go/bin\ncd /apptainer\n" >> .bashrc
USER apptainer_builder

#
# while in host root of apptainer repository:
# build the docker image with
#   docker build tools --file tools/Dockerfile.local.testing --progress plain --tag atbuild
#
# run the docker image with:
#   docker run --volume "$(PWD):/apptainer:rw" --network host --privileged --cap-add=CAP_MKNOD --device-cgroup-rule="b 7:* rmw" -it atbuild /bin/bash
#
# (while in running docker image) follow with:
#   ./mconfig -v -p /usr/local
#   make -C ./builddir all
#   sudo make -C ./builddir install
#
##################################
#
# (while in running docker image) -- after which you can run e2e tests with:
#   E2E_PARALLEL=8 make -C ./builddir e2e-test
#
# (while in running docker image) -- or run integration tests with:
#   make -C ./builddir integration-test
#
# (while in running docker image) -- or run short unit tests with:
#   make -C ./builddir short-unit-test
#
