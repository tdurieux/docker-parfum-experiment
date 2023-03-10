FROM centos:8

RUN yum update -y \
    && dnf group install -y "Development Tools" \
    && yum install -y \
      ncurses-compat-libs \
      python3 \
      python3-devel \
      wget && rm -rf /var/cache/yum

RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/bin/dumb-init
RUN alternatives --set  python /usr/bin/python3 \
    && python3 -m pip install virtualenv
