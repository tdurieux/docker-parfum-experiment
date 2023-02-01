FROM ubuntu:16.04
MAINTAINER Hongzhi Li <Hongzhi.Li@microsoft.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y dotnet-dev-1.0.0-preview2.1-003177 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dotnet-dev-1.0.0-preview2-003156 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dotnet-dev-1.0.1 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        python-dev \
        python-numpy \
        python-pip \
        python-yaml && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y bison curl nfs-common && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip;

RUN pip install --no-cache-dir setuptools;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask.restful