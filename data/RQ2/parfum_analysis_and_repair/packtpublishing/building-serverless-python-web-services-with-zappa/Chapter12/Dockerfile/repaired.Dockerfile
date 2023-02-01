FROM lambci/lambda:build-python3.6

MAINTAINER "Abdul Wahid" <abdulwahid24@gmail.com>



# Add your extra requirements here
RUN yum install -y wget && \
    pip install --no-cache-dir pipenv && rm -rf /var/cache/yum

WORKDIR /doc-parser

# Configure catdoc
RUN cd /tmp && \
    wget https://ftp.wagner.pp.ru/pub/catdoc/catdoc-0.95.tar.gz && \
    tar -xf catdoc-0.95.tar.gz && \
    cd catdoc-0.95/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/doc-parser/usr/ && \
    make && \
    make install && rm catdoc-0.95.tar.gz

COPY Pipfile Pipfile
RUN  pipenv install --deploy --system --skip-lock
