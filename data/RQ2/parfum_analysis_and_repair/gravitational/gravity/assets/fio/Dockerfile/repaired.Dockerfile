ARG BUILD_BOX
FROM ${BUILD_BOX}

ARG FIO_BRANCH
RUN env
RUN mkdir -p /gopath/native/fio && \
	    git clone https://github.com/axboe/fio.git --branch ${FIO_BRANCH} --single-branch /gopath/native/fio

RUN cd /gopath/native/fio && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --build-static && make

