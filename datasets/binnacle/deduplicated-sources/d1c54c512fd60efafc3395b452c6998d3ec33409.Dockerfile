# Go dependencies
#
# Fetches all required Go dependencies. All Linkerd sources are omitted from the resulting
# image so that artifacts may be built from source over this image.
#
# When this file is changed, run `bin/update-go-deps-shas`.

FROM golang:1.11.5
ENV TEMP_GOPATH=/temp-gopath
WORKDIR ${TEMP_GOPATH}/src/github.com/linkerd/linkerd2

# Download `dep` without being sensitive to changes to Gopkg.{toml,lock}.
COPY bin/dep bin/dep
RUN GOPATH=${TEMP_GOPATH} bin/dep version

# Vendor the Go dependencies. `dep ensure` caches the entire Git repo for
# every dependency in `${TEMP_GOPATH}/pkg/dep` so it is important to remove it.
# `go install` below cannot find the packages under vendor/ so move them to
# /go/src. This is all done in a single RUN to avoid creating a giant
# intermediate layer. `dep status` cannot be used here to ensure consistency
# because it needs all our source files, which are not available here.
COPY Gopkg.toml Gopkg.lock ./
RUN \
  GOPATH=${TEMP_GOPATH} bin/dep ensure -vendor-only -v && \
  mv vendor/* /go/src/ && \
  rm -rf ${TEMP_GOPATH}

# The previous WORKDIR was deleted. Reset it to avoid any potential for
# strangeness later.
WORKDIR /

# Precompile key slow-to-build dependencies. This list doesn't need to be
# complete for the build to work correctly; the completeness of this list
# only affects the speed of incremental rebuilds of Dependent Dockerfiles.
#
# This list was derived from the output of `find /go/pkg -type f`
# after building the controller.
RUN CGO_ENABLED=0 GOOS=linux go install \
    github.com/golang/protobuf/jsonpb \
    github.com/grpc-ecosystem/go-grpc-prometheus \
    github.com/prometheus/client_golang/api \
    github.com/prometheus/client_golang/api/prometheus/v1 \
    github.com/prometheus/client_golang/prometheus \
    github.com/prometheus/client_golang/prometheus/promhttp \
    github.com/prometheus/client_model/go \
    github.com/prometheus/common/expfmt \
    github.com/prometheus/common/model \
    github.com/sirupsen/logrus \
    github.com/containernetworking/cni/pkg/version \
    github.com/containernetworking/cni/pkg/skel \
    github.com/containernetworking/cni/pkg/types \
    github.com/containernetworking/cni/pkg/invoke \
    google.golang.org/grpc \
    k8s.io/client-go/discovery \
    k8s.io/client-go/kubernetes \
    k8s.io/client-go/kubernetes/scheme \
    k8s.io/client-go/kubernetes/typed/admissionregistration/v1alpha1 \
    k8s.io/client-go/kubernetes/typed/admissionregistration/v1beta1 \
    k8s.io/client-go/kubernetes/typed/apps/v1 \
    k8s.io/client-go/kubernetes/typed/apps/v1beta1 \
    k8s.io/client-go/kubernetes/typed/apps/v1beta2 \
    k8s.io/client-go/kubernetes/typed/authentication/v1 \
    k8s.io/client-go/kubernetes/typed/authentication/v1beta1 \
    k8s.io/client-go/kubernetes/typed/authorization/v1 \
    k8s.io/client-go/kubernetes/typed/authorization/v1beta1 \
    k8s.io/client-go/kubernetes/typed/autoscaling/v1 \
    k8s.io/client-go/kubernetes/typed/autoscaling/v2beta1 \
    k8s.io/client-go/kubernetes/typed/batch/v1 \
    k8s.io/client-go/kubernetes/typed/batch/v1beta1 \
    k8s.io/client-go/kubernetes/typed/batch/v2alpha1 \
    k8s.io/client-go/kubernetes/typed/certificates/v1beta1 \
    k8s.io/client-go/kubernetes/typed/core/v1 \
    k8s.io/client-go/kubernetes/typed/events/v1beta1 \
    k8s.io/client-go/kubernetes/typed/extensions/v1beta1 \
    k8s.io/client-go/kubernetes/typed/networking/v1 \
    k8s.io/client-go/kubernetes/typed/policy/v1beta1 \
    k8s.io/client-go/kubernetes/typed/rbac/v1 \
    k8s.io/client-go/kubernetes/typed/rbac/v1alpha1 \
    k8s.io/client-go/kubernetes/typed/rbac/v1beta1 \
    k8s.io/client-go/kubernetes/typed/scheduling/v1alpha1 \
    k8s.io/client-go/kubernetes/typed/settings/v1alpha1 \
    k8s.io/client-go/kubernetes/typed/storage/v1 \
    k8s.io/client-go/kubernetes/typed/storage/v1alpha1 \
    k8s.io/client-go/kubernetes/typed/storage/v1beta1 \
    k8s.io/client-go/pkg/version \
    k8s.io/client-go/plugin/pkg/client/auth \
    k8s.io/client-go/plugin/pkg/client/auth/azure \
    k8s.io/client-go/plugin/pkg/client/auth/gcp \
    k8s.io/client-go/plugin/pkg/client/auth/oidc \
    k8s.io/client-go/plugin/pkg/client/auth/openstack \
    k8s.io/client-go/rest \
    k8s.io/client-go/rest/watch \
    k8s.io/client-go/tools/auth \
    k8s.io/client-go/tools/cache \
    k8s.io/client-go/tools/clientcmd \
    k8s.io/client-go/tools/pager \
    k8s.io/client-go/transport \
    k8s.io/client-go/util/buffer \
    k8s.io/client-go/util/cert \
    k8s.io/client-go/util/flowcontrol \
    k8s.io/client-go/util/homedir \
    k8s.io/client-go/util/integer \
    k8s.io/client-go/util/jsonpath
