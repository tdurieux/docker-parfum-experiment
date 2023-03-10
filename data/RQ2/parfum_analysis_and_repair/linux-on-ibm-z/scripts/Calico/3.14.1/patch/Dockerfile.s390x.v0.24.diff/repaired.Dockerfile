diff --git a/Dockerfile.s390x b/Dockerfile.s390x
index 53b80c7..065fdfb 100644
--- a/Dockerfile.s390x
+++ b/Dockerfile.s390x
@@ -54,7 +54,7 @@ RUN go get github.com/golang/dep/cmd/dep
 RUN go get github.com/onsi/ginkgo/ginkgo
 
 # Install linting tools.
-RUN wget -O - -q https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.17.1
+RUN wget -O - -q https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.20.0
 RUN golangci-lint --version
 
 # Install license checking tool.