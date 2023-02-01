FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  npm \
  vim \
  wget && rm -rf /var/lib/apt/lists/*;

RUN ["wget", "https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.xz"]
ADD *.sh ./
ADD source/ /root/source
RUN ["git", "clone", "https://github.com/multiparty/jiff"]
RUN ["bash", "install.sh"]

RUN ["bash", "vim.sh"]
