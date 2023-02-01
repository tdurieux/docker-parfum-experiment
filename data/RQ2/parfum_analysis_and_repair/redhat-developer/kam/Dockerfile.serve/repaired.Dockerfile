FROM openshift/origin-release:golang-1.18 AS builder

WORKDIR /tmp/kam
COPY . .
RUN make all_platforms
RUN make checksum


FROM registry.redhat.io/rhel8/httpd-24

# Add application sources
RUN mkdir -p /var/www/html/kam
COPY --from=builder /tmp/kam/dist/kam_windows_amd64.exe /tmp/kam/dist/kam_linux_amd64 /tmp/kam/dist/kam_linux_ppc64le /tmp/kam/dist/kam_linux_s390x /tmp/kam/dist/kam_darwin_amd64 /tmp/kam/dist/kam_checksums.txt /var/www/html/kam/
COPY config/index.html /var/www/html/index.html
# The run script uses standard ways to run the application
CMD run-httpd