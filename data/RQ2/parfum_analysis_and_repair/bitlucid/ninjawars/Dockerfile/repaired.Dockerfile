FROM richarvey/nginx-php-fpm:2.1.2
# Comes with alpine linux 3.6

ARG username=nw

WORKDIR ./

COPY . .

ENV DBUSER=nwserver

# Various preps for alpine environment
RUN echo "Commencing PREP..." && \
	apk add --no-cache make && \
	apk add --no-cache --upgrade apk-tools && \
	apk update && \
	apk add --no-cache nodejs && \
	apk add --no-cache postgresql && \
	echo "Creating the resources file from the resources.build.php..." && \
	#sed "0,/postgres/{s/postgres/${DBUSER}/}" deploy/resources.build.php > deploy/resources.php && \
	#sed "s|/srv/ninjawars/|../..|g" deploy/tests/karma.conf.js > karma.conf.js && \
	echo "PREP done, starting install..." && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
	echo "Install not run."

ENV HOST=0.0.0.0 \
	PORT=7654

EXPOSE 7654

# Run with: docker run --rm -it -p 7654:7654 nw-server
CMD ["make" "test"]