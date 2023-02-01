FROM centos:7

MAINTAINER Mathias Lafeldt <mathias.lafeldt@gmail.com>

RUN yum update -y && yum install -y \
        curl \
        gcc \
        git \
        make \
        rpm-build \
        ruby \
        ruby-devel \
        tar

RUN echo "gem: --no-ri --no-rdoc" >/etc/gemrc
RUN gem install fpm -v 1.3.3
RUN gem install fpm-cookery -v 0.25.0

# Install recent version of Go. Use --no-deps below to not install Go again.
RUN curl -Ls https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz | \
    tar -C /usr/local -xz
ENV PATH $PATH:/usr/local/go/bin

VOLUME /data
WORKDIR /data

CMD ["fpm-cook", "package", "--debug", "--no-deps", "--tmp-root", "/tmp", "recipe.rb"]
