FROM quay.io/modcloth/percona-apt-repo:latest
MAINTAINER Platform <platform@modcloth.com>

RUN apt-get update -yq && apt-get install --no-install-recommends -yq \
    percona-server-server-5.6 \
    percona-server-client-5.6 \
    percona-toolkit \
    percona-xtrabackup && rm -rf /var/lib/apt/lists/*;
RUN /etc/init.d/mysql stop ; \
    usermod -d /mysql mysql && \
    rm -rf /etc/mysql /var/lib/mysql
RUN for dir in db logs bin config ; do \
  mkdir -p "/mysql/$dir" ; \
  done

ADD ./bin /mysql/bin

RUN chown -R mysql:mysql /mysql

EXPOSE 3306
VOLUME ["/mysql/db", "/mysql/logs", "/mysql/config"]
CMD ["/mysql/bin/run"]
