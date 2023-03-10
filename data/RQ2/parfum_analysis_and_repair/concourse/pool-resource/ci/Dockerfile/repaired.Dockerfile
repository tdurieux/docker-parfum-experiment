FROM concourse/static-golang

ADD http://stedolan.github.io/jq/download/linux64/jq /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq


RUN apt-get update && apt-get install --no-install-recommends -y zlib1g-dev gettext && rm -rf /var/lib/apt/lists/*;

ADD https://www.kernel.org/pub/software/scm/git/git-2.4.3.tar.gz /git/
RUN cd /git && tar xvf git-2.4.3.tar.gz && cd git-2.4.3 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-tcltk && \
  make && \
  make install && rm git-2.4.3.tar.gz
