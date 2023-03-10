# this dockerfile builds kitchen sync and runs a single sync from database to database over SSH.
# it needs to be built with the project repo root as the buildroot.
# note that the test is run as part of the build, you don't need to run anything afterwards.

FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		build-essential cmake openssh-server openssh-client \
		mysql-server libmysqlclient-dev && \
	apt-get clean -y && \
	rm -rf /var/cache/apt/archives/* && rm -rf /var/lib/apt/lists/*;

ADD CMakeLists.txt /tmp/CMakeLists.txt
ADD cmake /tmp/cmake/
ADD src /tmp/src/

WORKDIR /tmp/build
RUN mkdir /tmp/test
RUN touch /tmp/test/CMakeLists.txt
RUN cmake .. && make
RUN make install

ADD test/sync-test-source.sql /tmp/source.sql

RUN echo 'starting mysql' && \
		mkdir -p /var/run/mysqld && \
		chown mysql:mysql /var/run/mysqld && \
		(/usr/sbin/mysqld --skip-grant-tables &) && \
	echo 'waiting for mysql to start' && \
		mysqladmin --wait=30 ping && \
	echo 'creating mysql databases' && \
		mysqladmin create source && \
		mysqladmin create target && \
	echo 'populating source database' && \
		mysql -u root source </tmp/source.sql && \
	echo 'checking builds' && \
		ls -al /tmp/build && \
		mysql -V && \
	echo 'starting SSH server' && \
		mkdir /run/sshd && \
		/usr/sbin/sshd && \
	echo 'configuring SSH' && \
		mkdir ~/.ssh && \
		ssh-keyscan localhost >~/.ssh/known_hosts && \
		ssh-keygen -f ~/.ssh/id_rsa && \
		cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys && \
	echo 'running sync' && \
		ks --via localhost --from mysql://root@localhost/source --to mysql://root@localhost/target --alter --workers 4 --verbose && \
	echo 'comparing result' && \
		mysqldump -u root --compact source >a.sql && \
		mysqldump -u root --compact target >b.sql && \
		diff a.sql b.sql && \
	echo 'syncing both directions to check compatibility of created schema' && \
		ks --via localhost --from mysql://root@localhost/source --to mysql://root@localhost/target --workers 4 --verbose && \
		ks --via localhost --from mysql://root@localhost/target --to mysql://root@localhost/source --workers 4 --verbose
