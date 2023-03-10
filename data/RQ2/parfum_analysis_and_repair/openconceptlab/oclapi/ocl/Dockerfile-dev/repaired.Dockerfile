FROM python:2.7.16
ENV PYTHONUNBUFFERED 1

RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN echo 'root:Root123' | chpasswd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

EXPOSE 22

RUN touch /root/.bash_profile
RUN echo "cd /code" >> /root/.bash_profile

RUN mkdir /root/.ssh/
RUN touch /root/.ssh/environment

RUN mkdir /code
ADD . /code/
WORKDIR /code

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD bash startup.sh
