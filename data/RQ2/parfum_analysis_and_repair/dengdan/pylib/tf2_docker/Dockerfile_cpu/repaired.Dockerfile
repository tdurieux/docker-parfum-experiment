FROM tensorflow/tensorflow:latest-py3
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server tmux htop vim zsh git locales libopencv-dev libboost-all-dev python-tk sudo && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple Pillow scikit-learn protobuf scipy matplotlib setproctitle opencv-python ujson
#RUN pip3 install torch==1.3.1+cpu torchvision==0.4.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN mkdir /var/run/sshd
RUN echo 'root:1' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

