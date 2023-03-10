# This Dockerfile prepares an image equipped with all necessary softwares to prepare
# and upload SonarQube diagnostics
#
# Usage:
#    docker login registry.gitlab.inria.fr
#    docker build -f Dockerfile.sq -t registry.gitlab.inria.fr/gatb/simka/simka_sq .
#    docker push registry.gitlab.inria.fr/gatb/simka/simka_sq
#    NB: these tasks may be launched by gitlab-ci (manual job: update_simka_sq_image)
#
# References:
#    see eg https://sed-bso.gitlabpages.inria.fr/sonarqube/#sec-2-5

FROM debian:10

ENV FORCE_UNSAFE_CONFIGURE=1
ENV DEBIAN_FRONTEND noninteractive

LABEL maintainer="Charles Deltel <charles.deltel@inria.fr>"

RUN apt-get update
RUN apt install --no-install-recommends -y \
    make autoconf wget unzip \
    zlib1g-dev libcppunit-dev \
	git build-essential cmake clang clang-tidy gcovr lcov cppcheck valgrind python-pip pylint sudo vim tree \
	doxygen graphviz && rm -rf /var/lib/apt/lists/*; # for doxygen doc generation

RUN pip install --no-cache-dir --upgrade pip
RUN python -m pip install pytest pytest-cov setuptools scan-build

RUN chmod a+rx /root && \
    mkdir -p /root/apps

ENV version_rats 2.4
RUN cd /root/apps && \
    wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/rats-${version_rats}.tgz && \
    tar -xzvf rats-${version_rats}.tgz && \
    cd rats-${version_rats} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && sudo make install && \
    rm /root/apps/rats-${version_rats}.tgz

ENV version_drmemory 2.2.0-1
RUN cd /root/apps && \
    wget https://github.com/DynamoRIO/drmemory/releases/download/release_2.2.0/DrMemory-Linux-${version_drmemory}.tar.gz && \
    tar xf DrMemory-Linux-${version_drmemory}.tar.gz && \
    rm /root/apps/DrMemory-Linux-${version_drmemory}.tar.gz

RUN cd /root/apps && \
    wget --no-check-certificate https://scan.coverity.com/download/linux64 --post-data "token=XEJaJ1cAnqW-9M_zkmxd7w&project=Heat" -O coverity_tool.tgz && \
    tar xf coverity_tool.tgz && \
    ln -s -f $PWD/cov-analysis-linux64-*/bin/cov-build /usr/local/bin/cov-build && \
    rm /root/apps/coverity_tool.tgz

RUN cd /root/apps && \
    wget https://github.com/eriwen/lcov-to-cobertura-xml/archive/1.6.tar.gz && \
    tar xvf 1.6.tar.gz && \
    ln -s /root/apps/lcov-to-cobertura-xml-1.6/lcov_cobertura/lcov_cobertura.py /usr/local/bin/lcov_cobertura.py && \
    rm /root/apps/1.6.tar.gz

RUN cd /root/apps && \
    git clone https://github.com/SonarOpenCommunity/sonar-cxx.git && \
    chmod +x /root/apps/sonar-cxx/cxx-sensors/src/tools/vera++Report2checkstyleReport.perl && \
    ln -s /root/apps/sonar-cxx/cxx-sensors/src/tools/vera++Report2checkstyleReport.perl /usr/local/bin/vera++Report2checkstyleReport.perl

ENV version_sonar 4.5.0.2216
RUN cd /root/apps && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version_sonar}-linux.zip && \
    unzip sonar-scanner-cli-${version_sonar}-linux.zip && \
    ln -s /root/apps/sonar-scanner-${version_sonar}-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm /root/apps/sonar-scanner-cli-${version_sonar}-linux.zip

# cf. https://docs.docker.com/install/linux/docker-ce/debian/
#RUN apt-get remove docker docker-engine docker.io containerd runc
RUN sudo apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io && rm -rf /var/lib/apt/lists/*;

RUN docker --version

RUN groupadd -f -g 1000 gitlab && \
    useradd -u 1000 -g gitlab -d /home/gitlab/ -ms /bin/bash gitlab && \
    mkdir /builds && \
    chown -R gitlab:gitlab /builds && \
    echo "gitlab:gitlab" | chpasswd && adduser gitlab sudo

USER gitlab

# change the default shell to be bash
SHELL ["/bin/bash", "-c"]

# set DRMEMORY path (does not work without using an absolute path)
ENV DRMEMORY /root/apps/DrMemory-Linux-${version_drmemory}/bin64

# default working directory is
WORKDIR /builds
