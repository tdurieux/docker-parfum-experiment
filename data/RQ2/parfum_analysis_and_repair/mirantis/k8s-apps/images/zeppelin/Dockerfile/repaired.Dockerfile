FROM openjdk:8

ARG ZEPPELIN_VERSION=0.7.3-SNAPSHOT

# install zeppelin
# use apache.org when zeppelin will be released 0.7.3
# RUN curl http://www-eu.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz -o zeppelin.tgz \
RUN curl -f https://mirantisworkloads.storage.googleapis.com/bin/zeppelin/zeppelin-${ZEPPELIN_VERSION}.tar.gz -o zeppelin.tgz \
    && tar xvf zeppelin.tgz \
    && ln -s zeppelin-${ZEPPELIN_VERSION} zeppelin \
    && rm zeppelin.tgz

# install matplotlib integration
RUN apt update \
    && apt install --no-install-recommends -y python-matplotlib && rm -rf /var/lib/apt/lists/*;

# install R integration
RUN apt install --no-install-recommends -y r-base r-cran-knitr && rm -rf /var/lib/apt/lists/*;

ENV PATH /zeppelin/bin:$PATH
