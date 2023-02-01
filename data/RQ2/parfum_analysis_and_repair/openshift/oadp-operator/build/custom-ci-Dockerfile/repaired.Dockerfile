FROM openshift/origin-release:golang-1.16
RUN yum -y install epel-release --disablerepo=epel && yum clean all && rm -rf /var/cache/yum
RUN yum -y install make && rm -rf /var/cache/yum
RUN go get -u github.com/onsi/ginkgo/ginkgo && \
 go get -u github.com/onsi/ginkgo/v2/ginkgo
RUN go get github.com/onsi/gomega/...
RUN chmod g+rw /etc/passwd
ENV LC_ALL=en_US.utf-8 LANG=en_US.utf-8