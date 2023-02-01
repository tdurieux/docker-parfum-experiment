FROM ubuntu:latest

LABEL maintainer="amann@st.informatik.tu-darmstadt.de"

# settings
ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8 \
    GRADLE_VERSION=4.0.2 \
    GRADLE_HOME=/usr/local/gradle

# Setup container environment
RUN apt-get clean \
      && apt-get update \
      && apt-get install --no-install-recommends -y \
            software-properties-common \
            locales \
            ca-certificates \
            unzip \
      && update-ca-certificates \
      && locale-gen en_US en_US.UTF-8 \
      && dpkg-reconfigure locales \
      && echo -e "APT::Get::Assume-Yes \"true\";\nAPT::Get::force-yes \"true\";" >> /etc/apt/apt.conf.d/90forceyes \
      && apt-get install -y --no-install-recommends openjdk-8-jdk \
      && apt-get install -y --no-install-recommends wget \
      && apt-get clean \
      && apt-get autoclean \
      && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

# Setup pipeline environment
RUN apt-get update \
      # Install python \
      && apt-get install --no-install-recommends -y \
            python3-pip \
            python3 \
            python3-dev \
            python3-psutil \
      && ln -s python3 /usr/bin/python \
      && ln -s pip3 /usr/bin/pip \
      && pip3 install --no-cache-dir -r https://raw.githubusercontent.com/stg-tud/MUBench/master/mubench.pipeline/requirements.txt \
      # Install runtime dependencies
      && apt-get install --no-install-recommends -y \
            ant \
            git \
            graphviz \
            maven \
            subversion \
      # Install c lib pyyaml
      && wget -q https://pyyaml.org/download/libyaml/yaml-0.1.7.tar.gz \
      && tar xvf yaml-0.1.7.tar.gz -C /usr/local \
      && rm -f yaml-0.1.7.tar.gz \
      && cd /usr/local/yaml-0.1.7 \
      && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      && make \
      && make install \
      # Install git
      && apt-get install --no-install-recommends -y \
            git \
      && git config --global user.email "bob@builder.com" \
      && git config --global user.name "Bob the Builder" \
      # Install gradle
      && wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
      && unzip -q gradle-$GRADLE_VERSION-bin.zip -d /usr/local \
      && rm -f gradle-$GRADLE_VERSION-bin.zip \
      && ln -s /usr/local/gradle-$GRADLE_VERSION/bin/gradle /usr/bin/gradle \
      && apt-get clean \
      && apt-get autoclean \
      && apt-get autoremove && rm -rf /var/lib/apt/lists/*;



# Setup reviewsite environment
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
      && apt-get update \
      && apt-get install --no-install-recommends -y \
            php7.0 \
            php7.0-xml \
            php7.0-mbstring \
            php7.0-sqlite \
            php7.0-zip \
            php7.0-curl \
      # Install composer
      && wget -q https://getcomposer.org/installer -O composer-setup.php \
      && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
      && rm composer-setup.php \
      && apt-get clean \
      && apt-get autoclean \
      && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

# Setup test environment
RUN \

      wget -q https://phar.phpunit.de/phpunit-6.1.0.phar -O /usr/local/bin/phpunit \
      && chmod +x /usr/local/bin/phpunit \
      # Install nosetests \
      && pip3 install --no-cache-dir nose \
      # Install chromeium/chromedriver
      && apt-get install --no-install-recommends -y \
            chromium-browser \
            chromium-chromedriver \
      #Install selenium
            && wget -q https://selenium-release.storage.googleapis.com/3.12/selenium-server-standalone-3.12.0.jar \
          && mv selenium-server-standalone-3.12.0.jar /usr/local/bin/selenium-server-standalone-3.12.0.jar \
          && ln /usr/lib/chromium-browser/chromedriver /usr/local/bin/chromedriver && rm -rf /var/lib/apt/lists/*;

WORKDIR /mubench
