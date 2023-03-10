FROM centos:8

RUN yum -y install wget && rm -rf /var/cache/yum
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum -y install git tar gcc make bzip2 openssl openssl-devel patch gcc-c++ libffi-devel sqlite-devel && rm -rf /var/cache/yum
RUN git clone git://github.com/yyuu/pyenv.git ~/.pyenv
ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install 3.5.10 && pyenv install 3.6.14 && pyenv install 3.7.11 && pyenv install 3.8.11 && pyenv install 3.9.6 && pyenv install 3.10.1
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

WORKDIR /app
COPY . .
RUN [ "./run-tests.sh", "deploy"]
CMD [ "./run-tests.sh", "test"]
