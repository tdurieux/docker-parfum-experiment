FROM ubuntu:16.04


RUN apt-get update && apt-get install --no-install-recommends -y \
		dpkg \
		debconf \
		debhelper \
		lintian \
		md5deep \
		fakeroot \
		locales && rm -rf /var/lib/apt/lists/*;

# чтобы запустить тесты
RUN locale-gen --lang ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV ARTIFACTS_ROOT built/tmp

COPY ./ /opt/deb/
RUN mkdir /bld && cp /opt/deb/build.sh /bld/build.sh && chmod +x /bld/build.sh


