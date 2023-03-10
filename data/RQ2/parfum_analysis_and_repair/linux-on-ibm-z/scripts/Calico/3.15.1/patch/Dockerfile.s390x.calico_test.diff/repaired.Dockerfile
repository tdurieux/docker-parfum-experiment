diff --git a/calico_test/Dockerfile.s390x.calico_test b/calico_test/Dockerfile.s390x.calico_test
index 078620f..6601a03 100644
--- a/calico_test/Dockerfile.s390x.calico_test
+++ b/calico_test/Dockerfile.s390x.calico_test
@@ -59,7 +59,7 @@ RUN apk update \
 
 # Install etcdctl
 COPY pkg /pkg/
-RUN tar -xzf pkg/etcd-v3.3.1-linux-s390x.tar.gz -C /usr/local/bin/
+RUN tar -xzf pkg/etcd-v3.3.7-linux-s390x.tar.gz -C /usr/local/bin/
 
 # The container is used by mounting the code-under-test to /code
 WORKDIR /code/