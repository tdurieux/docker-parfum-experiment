FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server rsync task-spooler && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN [ -d /root/.ssh ] || mkdir -p /root/.ssh


# install sos on the remote host
RUN pip install --no-cache-dir spyder jedi notebook nbconvert nbformat pyyaml psutil tqdm
RUN pip install --no-cache-dir fasteners pygments ipython ptpython networkx pydotplus

RUN  SHA=$(git ls-remote https://github.com/vatlab/sos.git -t master)
RUN  SHA=$SHA git clone http://github.com/vatlab/sos sos
RUN cd sos && pip install --no-cache-dir . -U

RUN  echo "export TS_SLOTS=10" >> /root/.bash_profile
COPY ./.ssh/id_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
