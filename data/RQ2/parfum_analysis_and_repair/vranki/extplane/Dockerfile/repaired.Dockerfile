from ubuntu:bionic
RUN apt update -qq
RUN apt -yq --no-install-recommends install gnupg ca-certificates apt-transport-https software-properties-common git && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://mirror.mxe.cc/repos/apt bionic main" | tee /etc/apt/sources.list.d/mxeapt.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D43A795B73B16ABE9643FE1AFD8FFF16DB45C6AB
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C6BF758A33A3A276
RUN apt update -qq
RUN apt install --no-install-recommends -yq mxe-x86-64-w64-mingw32.static-qtbase mxe-x86-64-w64-mingw32.static-qtdeclarative && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -yq qtbase5-dev qtdeclarative5-dev qt5-default build-essential && rm -rf /var/lib/apt/lists/*;
RUN wget https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sample_templates/XPSDK300.zip
RUN unzip *.zip
RUN rm XPSDK300.zip
RUN mv SDK /XPlaneSDK
