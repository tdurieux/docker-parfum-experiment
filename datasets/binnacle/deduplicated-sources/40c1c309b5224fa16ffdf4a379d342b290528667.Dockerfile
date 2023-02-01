FROM anapsix/alpine-java:8_jdk

LABEL maintainer="amann@st.informatik.tu-darmstadt.de"

# Install ca-certificates so that HTTPS works consistently
RUN apk update \
 && apk add ca-certificates wget \
 && update-ca-certificates

ENV LANG=C.UTF-8 \
    GRADLE_VERSION=4.0.2 \
    GRADLE_HOME=/usr/local/gradle
ENV PATH=${PATH}:${GRADLE_HOME}/bin

# Setup pipeline environment
RUN apk update \
 \
 # Install Python
 && apk add \
      py3-psutil \
      python3 \
      yaml-dev \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && ln -s /usr/bin/pip3 /usr/bin/pip \
 && pip install --upgrade pip \
 \
 # Install runtime dependencies
 && apk add \
      apache-ant \
      git \
      graphviz \
      maven \
      subversion \
 \
 # Install gradle
 && wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
 && unzip -q gradle-$GRADLE_VERSION-bin.zip -d /usr/local \
 && rm -f gradle-$GRADLE_VERSION-bin.zip \
 && ln -s /usr/local/gradle-$GRADLE_VERSION /usr/local/gradle

# Setup reviewsite environment
RUN apk update \
 \
 # Install PHP
 && apk add \
      php7 \
      php7-ctype \
      php7-curl \
      php7-dom \
      php7-json \
      php7-mbstring \
      php7-openssl \
      php7-pdo \
      php7-pdo_sqlite \
      php7-phar \
      php7-session \
      php7-sqlite3 \
      php7-tokenizer \
      php7-xml \
      php7-xmlwriter \
      php7-zlib \
 \
 # Install Composer
 && wget -q https://getcomposer.org/installer -O composer-setup.php \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm composer-setup.php

# Install MUBench and configure interactive shell
WORKDIR /mubench
COPY . .
ARG mubench_version=v???
ENV PATH=/mubench/mubench.bin:${PATH}
CMD ["bash"]

RUN \
 ln -s /mubench/mubench.bin/bashrc /root/.bashrc \
 && echo $mubench_version > VERSION \
 # Setup pipeline
 && pip install -r /mubench/mubench.pipeline/requirements.txt \
 \
 # Setup reviewsite
 && composer install -d mubench.reviewsite --no-interaction --no-dev \
 && mkdir -p mubench.reviewsite/upload \
 && mkdir -p mubench.reviewsite/logs \
 \
 # Setup reviewsite standalone configuration
 && touch mubench.reviewsite/reviews.sqlite \
 && mv mubench.reviewsite/settings.docker.php mubench.reviewsite/settings.php

# Provide standalone reviewsite
EXPOSE 80
STOPSIGNAL SIGTERM
