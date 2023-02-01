FROM cgru/afcommon:2.0.8-ubuntu-14.04

LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>"
LABEL cgru_container_version="1.3.0"

EXPOSE 51000

CMD ["/opt/cgru/afanasy/bin/afserver"]