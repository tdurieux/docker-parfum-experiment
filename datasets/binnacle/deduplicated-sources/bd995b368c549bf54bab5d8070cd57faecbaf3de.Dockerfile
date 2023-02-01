FROM ubuntu:16.04

# 将 apt 源更换一下，速度更快。
ADD ./sources.list /etc/apt/

# 将 pip 源更换一下，提高下载速度。
RUN mkdir /root/.pip/
ADD ./pip.conf /root/.pip/

# install apt & pip3 package.
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y apt-utils wget openssh-server openssh-client python3 python3-pip \
# install java env path:/usr/bin/java
    && apt-get install -y software-properties-common python-software-properties \
    && add-apt-repository ppa:webupd8team/java && apt-get update \
    && apt-get install -y oracle-java8-installer && update-java-alternatives -s java-8-oracle \
# install scala env path:/usr/bin/scala
    && apt-get install -y scala \
# install python3 package
    && pip3 install ipython -i https://pypi.douban.com/simple/ \
    && rm -rf /var/lib/apt/lists/* && apt-get clean \
    && rm -rf ~/.cache/pip/

# oh-my-zsh 并且更为 zsh 风格 ys，将 zsh 替代默认的bash。
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && cp ~/.zshrc ~/.zshrc.orig \
    && chsh -s /bin/zsh \
    && sed -ri 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' /root/.zshrc

RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

# ssh.
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/.*StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config

# 直接在此处设置免密登录,便于后续的操作。
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \ 
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && \
    chmod 600 ~/.ssh/id_rsa && \
    chmod 644 ~/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
