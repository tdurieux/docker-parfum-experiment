FROM gcr.io/distroless/base-debian10
MAINTAINER gou@portworx.com

EXPOSE 9005 9100 9110
ADD _tmp/osd /
ENTRYPOINT ["/osd"]