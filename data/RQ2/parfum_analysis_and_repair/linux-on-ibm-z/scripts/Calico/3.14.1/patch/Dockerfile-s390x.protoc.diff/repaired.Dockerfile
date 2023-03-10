diff --git a/Dockerfile-s390x b/Dockerfile-s390x
index 0ead8c4..c3b249f 100644
--- a/Dockerfile-s390x
+++ b/Dockerfile-s390x
@@ -32,6 +32,8 @@ RUN go get github.com/gogo/protobuf/proto \
        github.com/gogo/protobuf/protoc-gen-gogofaster \
        github.com/gogo/protobuf/protoc-gen-gogoslick
 
+RUN cd $GOPATH/src/github.com/gogo/protobuf && git checkout -f 160de10b2537169b5ae3e7e221d28269ef40d311 && make install
+
 RUN apt-get purge -y git make autoconf automake libtool unzip && apt-get clean -y
 
 ENTRYPOINT ["protoc"]