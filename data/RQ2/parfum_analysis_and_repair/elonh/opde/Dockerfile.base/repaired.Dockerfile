FROM ubuntu:latest
LABEL maintainer="Elon Huang <elonhhuang@gmail.com>"

# 使用国内APT镜像源
ARG CHINESE_APT_MIRRORS=0
RUN [ $CHINESE_APT_MIRRORS -eq 1 ] && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list || true

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y &&\
	apt-get install -y --no-install-recommends \
	sudo python3-dev libyaml-dev cmake gcc g++ make apt-utils hugo \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /root/.cache/*

RUN apt-get update -y &&\
	apt-get install -y --no-install-recommends \
	build-essential asciidoc binutils bzip2 gawk gdisk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev \
	lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core \
	gcc-multilib g++-multilib p7zip p7zip-full msmtp libssl-dev texinfo libreadline-dev libglib2.0-dev xmlto \
	qemu-utils upx libelf-dev autoconf automake libtool autopoint \
	ccache curl wget vim nano python3 python3-pip python3-ply python2 \
	haveged lrzsz device-tree-compiler scons antlr3 gperf intltool rsync mkisofs \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /root/.cache/*

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} opde &&\
	useradd -c "OpenWrt Builder" -l -m -d /home/opde -u ${USER_ID} -g opde -G sudo -s /bin/bash opde &&\
	echo '%opde ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers &&\
	install -d -m 0754 -o opde -g opde /openwrt

USER opde:opde
ENV HOME /home/opde
WORKDIR /openwrt


# 使用国内PIP镜像源
ARG CHINESE_PIP_MIRRORS=0
RUN [ $CHINESE_PIP_MIRRORS -eq 1 ] && \
	sudo -E -H pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple && \
	sudo -E -H pip3 config set install.trusted-host mirrors.aliyun.com || true

# running `poetry export -f requirements.txt -o requirements.txt` to update python packages
# install opde runtime enviroment
COPY ./requirements.txt /requirements.txt
RUN sudo -E -H pip3 install --no-cache-dir -r /requirements.txt \
	&& sudo -E rm -rf /root/.cache/* /requirements.txt

# install upload/download tool:
#   transfer https://github.com/Mikubill/transfer
#   OneList https://github.com/MoeClub/OneList
RUN curl -f -sL https://git.io/file-transfer | sh && \
	sudo mv ./transfer /usr/bin && \
	curl -f -sL https://raw.githubusercontent.com/MoeClub/OneList/master/OneDriveUploader/amd64/linux/OneDriveUploader -o OneDriveUploader && \
	sudo chmod +x ./OneDriveUploader && \
	sudo mv ./OneDriveUploader /usr/bin

# install dev tools
RUN sudo -E apt-get update -y &&\
	sudo -E apt-get install -y --no-install-recommends \
	zsh ack tree htop \
	&& sudo -E apt-get -y autoremove && sudo -E apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /root/.cache/*

# setup zsh
RUN CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" && \
	sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' ~/.zshrc && \
	git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions && \
	git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
	sed -i 's/plugins=(git)/plugins=(git extract sudo zsh-syntax-highlighting zsh-completions history-substring-search zsh-autosuggestions)\nautoload -U compinit \&\& compinit/g' ~/.zshrc

ENV PATH="/opde:${PATH}"

ENV OPDE_MODE=BASE
COPY opde /opde/opde
COPY src /opde/src

# TODO: seprerate
# OpenWRT Target System
ARG TARGET=x86
ARG SUBTARGET=64
ENV OPDE_TARGET=${TARGET}
ENV OPDE_SUBTARGET=${SUBTARGET}
