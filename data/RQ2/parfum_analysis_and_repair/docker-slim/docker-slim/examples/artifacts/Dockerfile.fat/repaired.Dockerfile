# new image
ADD file:feb9fd29475961253e3449db036bbf56bf6f4d02f2df1202209e393a9e7e95f5 in /
CMD ["bash"]
RUN apt-get update && \
	apt-get install -y --no-install-recommends 		ca-certificates 		curl 		netbase 		wget && \
	rm -rf /var/lib/apt/lists/*
RUN set -ex; 	if ! command -v gpg > /dev/null; then 		apt-get update; 		apt-get install -y --no-install-recommends 			gnupg 			dirmngr 		; 		rm -rf /var/lib/apt/lists/*; 	fi
RUN apt-get update && \
	apt-get install -y --no-install-recommends 		bzr 		git 		mercurial 		openssh-client 		subversion 				procps && \
	rm -rf /var/lib/apt/lists/*
RUN set -ex; 	apt-get update; 	apt-get install -y --no-install-recommends 		autoconf 		automake 		bzip2 		dpkg-dev 		file 		g++ 		gcc 		imagemagick 		libbz2-dev 		libc6-dev 		libcurl4-openssl-dev 		libdb-dev 		libevent-dev 		libffi-dev 		libgdbm-dev 		libgeoip-dev 		libglib2.0-dev 		libjpeg-dev 		libkrb5-dev 		liblzma-dev 		libmagickcore-dev 		libmagickwand-dev 		libncurses5-dev 		libncursesw5-dev 		libpng-dev 		libpq-dev 		libreadline-dev 		libsqlite3-dev 		libssl-dev 		libtool 		libwebp-dev 		libxml2-dev 		libxslt-dev 		libyaml-dev 		make 		patch 		unzip 		xz-utils 		zlib1g-dev 				$( 			if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then 				echo 'default-libmysqlclient-dev'; 			else 				echo 'libmysqlclient-dev'; 			fi 		) 	; 	rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/etc && \
	{ 		echo 'install: --no-document'; 		echo 'update: --no-document'; 	} >> /usr/local/etc/gemrc
ENV RUBY_MAJOR=2.5
ENV RUBY_VERSION=2.5.3
ENV RUBY_DOWNLOAD_SHA256=1cc9d0359a8ea35fc6111ec830d12e60168f3b9b305a3c2578357d360fcf306f
ENV RUBYGEMS_VERSION=3.0.1
RUN set -ex && \
	buildDeps=' 		bison 		dpkg-dev 		libgdbm-dev 		ruby 	' && \
	apt-get update && \
	apt-get install -y --no-install-recommends $buildDeps && \
	rm -rf /var/lib/apt/lists/* && \
	wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR%-rc}/ruby-$RUBY_VERSION.tar.xz" && \
	echo "$RUBY_DOWNLOAD_SHA256  *ruby.tar.xz" | sha256sum -c - && \
	mkdir -p /usr/src/ruby && \
	tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1 && \
	rm ruby.tar.xz && \
	cd /usr/src/ruby && \
	{ 		echo '#define ENABLE_PATH_CHECK 0'; 		echo; 		cat file.c; 	} > file.c.new && \
	mv file.c.new file.c && \
	autoconf && \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	./configure 		--build="$gnuArch" 		--disable-install-doc 		--enable-shared && \
	make -j "$(nproc)" && \
	make install && \
	apt-get purge -y --auto-remove $buildDeps && \
	cd / && \
	rm -r /usr/src/ruby && \
	ruby -e 'exit(Gem::Version.create(ENV["RUBYGEMS_VERSION"]) > Gem::Version.create(Gem::VERSION))' && \
	gem update --system "$RUBYGEMS_VERSION" && \
	rm -r /root/.gem/ && \
	ruby --version && \
	gem --version && \
	bundle --version
ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=/usr/local/bundle BUNDLE_SILENCE_ROOT_WARNING=1 BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:/usr/local/bundle/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p "$GEM_HOME" && \
	chmod 777 "$GEM_HOME"
CMD ["irb"]
# end of image: ruby:2.5.3 (id: sha256:feea8cad6f9e7cc58f7ae793ac92bd80fa1ce4da54a381921f161447e978021f tags: ruby:2.5.3)

# new image
WORKDIR /opt/my/service
COPY dir:72f39c4da5590184efef429c25213a78f2ce664a919b4c0578c7ebe8b43747a1 in /opt/my/service
RUN bundle install
EXPOSE 3333
ENTRYPOINT ["rails" "server" "--binding=0.0.0.0" "--port=3333" "--environment=development"]
# end of image: my/ruby-rails-app:latest (id: sha256:7888eedcb28c19cc47deb8fece184cf331872ade41e092dd97a1340baefb530d tags: my/ruby-rails-app:latest)
