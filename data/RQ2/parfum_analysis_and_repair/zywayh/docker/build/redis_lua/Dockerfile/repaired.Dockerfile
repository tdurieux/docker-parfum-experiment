FROM redis

# add lua to container
# add支持拷贝进容器后自动解压缩
# ADD lua-5.3.5.tar.gz /
ADD http://www.lua.org/ftp/lua-5.3.5.tar.gz /

RUN apt-get update
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN make -C /lua-5.3.5 linux
RUN make -C /lua-5.3.5 install