From: Cristina Pauna <cristina.pauna@enea.com>
Date: Mon, 23 Jul 2018 15:16:59 +0300
Subject: [PATCH] Patch for Yardstick AARCH64 Docker file

Signed-off-by: Cristina Pauna <cristina.pauna@enea.com>
---
 docker/Dockerfile | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/docker/Dockerfile b/docker/Dockerfile
index 71ce6b58..fce7c116 100644
--- a/docker/Dockerfile
+++ b/docker/Dockerfile
@@ -7,9 +7,9 @@
 # http://www.apache.org/licenses/LICENSE-2.0
 ##############################################################################

-FROM ubuntu:16.04
+FROM arm64v8/ubuntu:16.04

-LABEL image=opnfv/yardstick
+LABEL image=opnfv/yardstick_aarch64

 ARG BRANCH=master

@@ -24,7 +24,8 @@ ENV YARDSTICK_REPO_DIR="${REPOS_DIR}/yardstick/" \
     RELENG_REPO_DIR="${REPOS_DIR}/releng" \
     STORPERF_REPO_DIR="${REPOS_DIR}/storperf"

-RUN apt-get update && apt-get install -y git python python-setuptools python-pip iputils-ping && apt-get -y autoremove && apt-get clean
+RUN apt-get update && apt-get install -y git python python-setuptools python-pip iputils-ping && apt-get -y autoremove && \
+    apt-get install -y libssl-dev && apt-get -y install libffi-dev && apt-get clean
 RUN easy_install -U setuptools==30.0.0
 RUN pip install --no-cache-dir appdirs==1.4.0 pyopenssl==17.5.0 openstacksdk==0.11.3 python-openstackclient==3.14.2 python-heatclient==1.14.0 ansible==2.5.5

@@ -40,7 +41,8 @@ RUN git clone --depth 1 -b $BRANCH https://gerrit.opnfv.org/gerrit/yardstick ${Y
 RUN git clone --depth 1 https://gerrit.opnfv.org/gerrit/releng ${RELENG_REPO_DIR}
 RUN git clone --depth 1 -b stable/gambia https://gerrit.opnfv.org/gerrit/storperf ${STORPERF_REPO_DIR}

-RUN ansible-playbook -i ${YARDSTICK_REPO_DIR}/ansible/install-inventory.ini -c local -vvv -e INSTALLATION_MODE="container" ${YARDSTICK_REPO_DIR}/ansible/install.yaml
+RUN sed -i -e '/configure_gui/d' ${YARDSTICK_REPO_DIR}/ansible/install.yaml && \
+    ansible-playbook -i ${YARDSTICK_REPO_DIR}/ansible/install-inventory.ini -c local -vvv -e INSTALLATION_MODE="container" ${YARDSTICK_REPO_DIR}/ansible/install.yaml

 RUN ${YARDSTICK_REPO_DIR}/docker/supervisor.sh

@@ -48,8 +50,8 @@ RUN echo "daemon off;" >> /etc/nginx/nginx.conf
 # nginx=5000, rabbitmq=5672
 EXPOSE 5000 5672

-ADD http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img ${IMAGE_DIR}
-ADD http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img ${IMAGE_DIR}
+ADD http://download.cirros-cloud.net/daily/20161201/cirros-d161201-aarch64-disk.img ${IMAGE_DIR}
+ADD http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-arm64-disk1.img ${IMAGE_DIR}

 # For developers: when `docker build ...` is running from YARDSTICK_REPO_DIR, please change
 #                 path `./exec_tests.sh` -> `./docker/exec_tests.sh``.
