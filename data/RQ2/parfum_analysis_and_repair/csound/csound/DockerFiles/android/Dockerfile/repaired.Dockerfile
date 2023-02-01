#specify the base OS

FROM npetrovsky/docker-android-sdk-ndk

#Running apt updates on OS
ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]

#RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN apt-get update -y

#RUN apt-get upgrade -y


#Running installations on the os

RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends cmake -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends flac -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends zip -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends gzip -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends flex -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends bison -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends swig -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends texlive-full -y && rm -rf /var/lib/apt/lists/*;

#RUN apt-get build-dep csound -y


CMD ["/bin/bash" , "-c" , "git clone https://github.com/csound/csound.git && export ANDROID_NDK_ROOT=\"/opt/android-sdk-linux/ndk-bundle\" && export NDK_MODULE_PATH=\"/csound/Android/\" &&  cd /csound/Android/ && ./downloadDependencies.sh && ./build-all.sh &&./release.sh"]