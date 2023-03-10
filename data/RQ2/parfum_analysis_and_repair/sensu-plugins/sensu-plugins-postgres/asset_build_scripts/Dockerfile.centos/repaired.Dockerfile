FROM sensu/sensu-ruby-runtime-2.4.4-centos:latest as builder
ARG ASSET_GEM
ARG GIT_REF
ARG GIT_REPO
ARG GREP_EXCLUDE='(ld.so|ld-linux-x86-64.so|libBrokenLocale.so|libSegFault.so|libanl.so|libc.so|libdl.so|libm.so|libmvec.so|libnss_compat.so|libnss_dns.so|libnss_files.so|libpthread.so|libresolv.so|librt.so|libthread_db.so|libutil.so|vdso.so)'
ARG RUBY_VERSION=2.4.4

WORKDIR /assets/build/
RUN yum install -y git && rm -rf /var/cache/yum
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y postgresql95 postgresql95-libs postgresql95-devel && rm -rf /var/cache/yum
ENV CONFIGURE_ARGS="with-pg-config=/usr/pgsql-9.5/bin/pg_config"
RUN \
  gem install --no-ri --no-doc bundler && \
  printf "source 'https://rubygems.org'\n\ngem \"%s\", :git => \"%s\" , :ref => \"%s\"\n" ${ASSET_GEM} ${GIT_REPO} ${GIT_REF}| tee Gemfile
RUN bundle install --path=lib/ --binstubs=bin/ --standalone

RUN LIBS=$(find ./ -type f -executable -exec ldd {} 2>/dev/null \;|  grep "=>" | egrep -v ${GREP_EXCLUDE} | awk '{print $3}'| sort -u ) && \
  for f in $LIBS; do if [ -e $f ] && [ ! -e /opt/rubies/ruby-${RUBY_VERSION}/lib/$f ] ; then echo "Copying Library: $f" && cp $f ./lib/; fi; done

RUN tar -czf /assets/${ASSET_GEM}.tar.gz -C /assets/build/ . && rm /assets/${ASSET_GEM}.tar.gz

FROM scratch
ARG ASSET_GEM
COPY --from=builder /assets/${ASSET_GEM}.tar.gz /
