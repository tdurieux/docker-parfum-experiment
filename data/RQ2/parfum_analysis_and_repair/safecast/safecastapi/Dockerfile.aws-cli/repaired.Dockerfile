#
# Dockerfile for aws-cli
#
# To build:
#
#  $ docker build -f Dockerfile.aws-cli -t aws-cli:latest
#
# To run:
#
#  $ docker run --rm -it --env-file <(aws-vault exec safecast --no-session -- env | grep --color=no '^AWS_') -v $(pwd):/aws aws-cli:latest
#
# You need to run aws-vault before running.

FROM amazon/aws-cli:latest

RUN yum group install -y "Development Tools" && \
yum install -y zlib-devel openssl-devel ncurses-devel libffi-devel \
sqlite-devel.x86_64 readline-devel.x86_64 bzip2-devel.x86_64 && rm -rf /var/cache/yum
RUN git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
RUN ./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
RUN echo 'export PATH="~/.pyenv/versions/3.7.2/bin:~/.ebcli-virtual-env/executables:$PATH"' >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]
