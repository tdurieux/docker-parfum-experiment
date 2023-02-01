#specify the base OS

FROM ubuntu:latest

#Running apt updates on OS
ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]

RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list

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

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

RUN npm i -g jsdoc && npm cache clean --force;

RUN apt-get build-dep csound -y



#setting up emsdk
RUN git clone https://github.com/emscripten-core/emsdk.git

RUN cd emsdk/ && git pull && ./emsdk install latest && ./emsdk activate latest

#Running build commands once container starts
CMD ["/bin/bash" , "-c" , "source emsdk/emsdk_env.sh && git clone https://github.com/csound/csound.git && cd csound/Emscripten && sh ./download_and_build_libsndfile.sh || sh ./build.sh && sh ./update_example_libs_from_dist.sh && sh  ./release.sh"]


ENV DEBIAN_FRONTEND teletype

