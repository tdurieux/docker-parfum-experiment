FROM ubuntu:20.04

ENV WDIR=trustee
ENV ANDROID_HOME=/${WDIR}/androidsdk \
    ANDROID_SDK_ROOT=/${WDIR}/androidsdk \
    TZ=Europe/Kiev

WORKDIR /${WDIR}

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qq -y install sudo build-essential openjdk-8-jdk git curl sudo pigz unzip python3-distutils python3-apt && \
    ln -fs /usr/share/zoneinfo/Europe/Kiev /etc/localtime && \
    sudo dpkg-reconfigure --frontend noninteractive tzdata && date && \
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    python3 -m pip install gplaycli && \
    rm -f ./get-pip.py && \
    curl -f -sL -o /usr/local/bin/apktool https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && \
    curl -f -sL -o /usr/local/bin/apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.0.jar && \
    chmod +x /usr/local/bin/apktool /usr/local/bin/apktool.jar && \
    curl -f -sL -o bundletool.jar https://github.com/google/bundletool/releases/download/1.8.0/bundletool-all-1.8.0.jar && \
    chmod 644 bundletool.jar && \
    curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get -y --no-install-recommends install nodejs && \
    npm install --global yarn && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && npm cache clean --force;

RUN echo "JAVA_HOME=$(which java)" | sudo tee -a /etc/environment && \
    . /etc/environment

RUN mkdir -p /${WDIR}/npm && \
    mkdir -p /${WDIR}/src && \
    mkdir -p /${WDIR}/androidsdk/cmdline-tools/latest

ADD . ./src

RUN cd ./src && \
    yarn install --no-progress && \
    tar -c --use-compress-program=pigz -f /${WDIR}/npm/node_modules.tar.gz /${WDIR}/src/node_modules && \
    rm -rf /${WDIR}/src && \
    mkdir /${WDIR}/src && yarn cache clean; && rm /${WDIR}/npm/node_modules.tar.gz

RUN cd /${WDIR}/androidsdk/cmdline-tools/ && \
    curl -f -s -o commandlinetools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    unzip commandlinetools-linux.zip && \
    cd ./cmdline-tools/ && \
    mv ./* ../latest/ && \
    cd .. && \
    rm -rf ./cmdline-tools && rm -f commandlinetools-linux.zip && \
    ln -sf /trustee/androidsdk/cmdline-tools/latest/bin/sdkmanager /usr/bin/sdkmanager && \
    yes | sdkmanager --licenses


