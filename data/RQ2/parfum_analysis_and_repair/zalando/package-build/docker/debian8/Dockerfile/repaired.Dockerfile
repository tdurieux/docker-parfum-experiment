FROM debian:8
MAINTAINER soeren.koenig@zalando.de

ENV DIST debian8
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/go/bin

COPY zalando/ /usr/share/ca-certificates/zalando/

RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev python-setuptools python-dev python-pip build-essential git-core curl lsb-release unzip mercurial && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN curl -f -O https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.5.3.linux-amd64.tar.gz && rm go1.5.3.linux-amd64.tar.gz

COPY pip.conf /etc/pip.conf
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir virtualenv virtualenv-tools

RUN gem install --no-rdoc --no-ri json_pure --version 1.7.7
RUN gem install --no-rdoc --no-ri fpm-cookery

RUN echo 'zalando/zalando-service-combined.crt' >> '/etc/ca-certificates.conf'
RUN /usr/sbin/update-ca-certificates

ADD http://repo.zalando/static/.netrc /root/.netrc
