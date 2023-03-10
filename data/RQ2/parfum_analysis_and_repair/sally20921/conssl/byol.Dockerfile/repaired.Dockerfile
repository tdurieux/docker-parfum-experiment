# pytorch-cuda image as a base
# mark this image as "pytorch-base"
FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-devel AS pytorch-base
MAINTAINER Seri Lee <sally20921@snu.ac.kr>
USER root

# install system-wide deps
RUN apt-get -yqq update --fix-missing && apt-get install --no-install-recommends -y sudo \
	build-essential \
	git \
	bash \
	wget \
	curl \
	ssh \
	apt-utils \






	vim \
	neovim \
	zsh \
	locales \











	time \




	nano \

	tree \



	python3-dev \
	python3-pip \
	python3-setuptools && rm -rf /var/lib/apt/lists/*;

WORKDIR /

# create /code and /data directories
#RUN mkdir -p /home/data
#ADD ./code /code
RUN cd /home
RUN git clone https://github.com/sally20921/BYOL.git
#RUN cd ./SwAV
#RUN mkdir -p ./data
#COPY ./code/requirements.txt /home/requirements.txt

# install dependencies
RUN cd ./BYOL/code
RUN pip3 -q --no-cache-dir install pip --upgrade
RUN pip3 install --no-cache-dir --ignore-installed -r requirements.txt

# set the locale
#RUN locale-gen --purge en._US.UTF-8
#RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale
#RUN dpkg-reconfigure --frontend=noninteractive locales
RUN chmod 777 /

# ohmyzsh and vim
#RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \    
#    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
#    && git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions \
#    && git clone https://github.com/amix/vimrc.git ~/.vim_runtime \
#    && sh ~/.vim_runtime/install_awesome_vimrc.sh
# COPY ./zshrc /.zshrc

CMD ["/bin/bash"]
#CMD ["/bin/zsh"]
