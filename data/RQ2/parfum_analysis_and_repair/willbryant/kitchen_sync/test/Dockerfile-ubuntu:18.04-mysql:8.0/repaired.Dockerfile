# this dockerfile builds kitchen sync and runs the test suite.  it needs to be built with the project repo root as the buildroot.
# note that the tests are run as part of the build, you don't need to run anything afterwards.

FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		build-essential cmake libssl-dev \
		git ruby ruby-dev software-properties-common dirmngr gpg-agent && \
	apt-get clean -y && \
	rm -rf /var/cache/apt/archives/* && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 5072E1F5 && \
	DEBIAN_FRONTEND=noninteractive add-apt-repository 'deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-8.0' && \
	DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		mysql-server libmysqlclient-dev && \
	apt-get clean -y && \
	rm -rf /var/cache/apt/archives/* && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler -v 1.17.3 --no-ri --no-rdoc

WORKDIR /tmp
COPY test/Gemfile Gemfile
COPY test/Gemfile.lock Gemfile.lock
RUN bundle config --global silence_root_warning 1 && bundle install --without postgresql --path ~/gems

ADD CMakeLists.txt /tmp/CMakeLists.txt
ADD cmake /tmp/cmake/
ADD src /tmp/src/
ADD test/CMakeLists.txt test/*.cpp /tmp/test/

WORKDIR /tmp/build
RUN cmake .. && make

ADD test /tmp/test
RUN echo 'starting mysql' && \
		mkdir -p /var/run/mysqld && \
		chown mysql:mysql /var/run/mysqld && \
		(/usr/sbin/mysqld --skip-grant-tables --user=root &) && \
	echo 'waiting for mysql to start' && \
		mysqladmin --wait=30 ping && \
	echo 'creating mysql database' && \
		mysqladmin create ks_test && \
	echo 'installing test gems' && \
		BUNDLE_GEMFILE=../test/Gemfile bundle install --without postgresql --path ~/gems && \
	echo 'checking builds' && \
		ls -al /tmp/build && \
		mysql -V && \
	echo 'running tests' && \
		CTEST_OUTPUT_ON_FAILURE=1 ENDPOINT_DATABASES=mysql make test
