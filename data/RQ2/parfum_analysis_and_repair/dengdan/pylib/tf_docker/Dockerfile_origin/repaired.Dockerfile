#FROM tensorflow/tensorflow:1.14.0-gpu-py3
FROM dengdan/tensorflow-gpu:tf14
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux htop vim zsh git locales libopencv-dev libboost-all-dev python-tk sudo && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple Pillow scikit-learn protobuf scipy matplotlib setproctitle opencv-python
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple ujson
RUN mkdir /var/run/sshd
RUN echo 'root:1' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "alias p='python'" >> /etc/profile
RUN echo "alias n='nvidia-smi'" >> /etc/profile
RUN echo "alias wn='watch nvidia-smi'" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

