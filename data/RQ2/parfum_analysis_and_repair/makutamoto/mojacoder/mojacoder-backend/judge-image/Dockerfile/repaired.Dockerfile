FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y
RUN apt install --no-install-recommends -y gnupg ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update

RUN apt install --no-install-recommends -y golang-1.14 && rm -rf /var/lib/apt/lists/*;
ENV PATH $PATH:/usr/lib/go-1.14/bin/
RUN apt install --no-install-recommends -y python3.8 build-essential mono-devel bf cargo pypy3 ruby2.7 default-jdk sbcl && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
RUN apt install --no-install-recommends -y wget curl zip && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.jsoftware.com/download/j902/install/j902_amd64.deb
RUN mkdir -p /usr/share/icons/hicolor/scalable/apps/
RUN dpkg -i j902_amd64.deb
RUN echo -e "load 'pacman'\n'update' jpkg ''\n'install' jpkg 'dev/fold'\n" | ijconsole
RUN curl -f -s https://get.sdkman.io | bash && source ~/.sdkman/bin/sdkman-init.sh && sdk install kotlin
RUN wget https://github.com/atcoder/ac-library/archive/master.zip
RUN unzip ./master.zip
RUN mv ./ac-library-master/atcoder /usr/local/include/
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.zip
RUN unzip ./boost_1_76_0.zip
RUN mv ./boost_1_76_0/boost /usr/local/include/

RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir numpy
RUN pypy3 -m pip install numpy

RUN groupadd -r -g 400 code && useradd -r -u 400 -g 400 code

WORKDIR /usr/src/app
COPY . .
RUN go build .

WORKDIR /usr/src/app/rust
RUN cargo build --release

RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
ENTRYPOINT ./judge
