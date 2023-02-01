FROM ubuntu:20.04
 ARG USER_NAME
 ARG USER_ID
 ARG GROUP_ID
# We install some useful packages
 RUN apt-get update -qq
 RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata gnuplot && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y vim ninja-build valgrind golang curl llvm gdb lldb clang-format sudo pip python python-dev wget cmake g++ g++-9 git clang++-9 linux-tools-generic ruby ruby-dev python3-pip libboost-all-dev r-base-dev r-recommended qpdf devscripts r-cran-remotes && rm -rf /var/lib/apt/lists/*;
 RUN pip3 install --no-cache-dir ipython

# Moar compilers
 RUN apt-get install --no-install-recommends -y clang++-6 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y clang++-7 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y clang++-8 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y clang++-9 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y clang++-10 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y clang++-11 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y g++-7 g++-8 g++-9 g++-10 && rm -rf /var/lib/apt/lists/*;
 RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;

 RUN addgroup --gid $GROUP_ID user; exit 0
 RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER_NAME; exit 0
 RUN echo "$USER_NAME:$USER_NAME" | chpasswd && adduser $USER_NAME sudo
 RUN echo '----->'
 RUN echo 'root:Docker!' | chpasswd
 ENV TERM xterm-256color
 USER $USER_NAME

 RUN gcc --version
 RUN cmake --version
 RUN python3 --version
 RUN pip3 --version
 RUN go version
