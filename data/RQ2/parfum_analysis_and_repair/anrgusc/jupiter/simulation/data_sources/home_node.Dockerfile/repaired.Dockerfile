# Instructions copied from - https://hub.docker.com/_/python/
FROM ubuntu:16.04

RUN apt-get -yqq update
RUN apt-get -yqq --no-install-recommends install python3-pip python3-dev libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-server mongodb && rm -rf /var/lib/apt/lists/*;
ADD simulation/data_sources/requirements_data.txt /requirements.txt
RUN apt-get -y --no-install-recommends install build-essential libssl-dev libffi-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get install --no-install-recommends -y sshpass nano && rm -rf /var/lib/apt/lists/*;


RUN pip3 install --no-cache-dir -r requirements.txt
RUN echo 'root:PASSWORD' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir generated_stream
# Add the task speficific configuration files
ADD app_specific_files/dummy_app/configuration.txt /configuration.txt
ADD simulation/data_sources/ds_test.py /ds_test.py
ADD simulation/data_sources/generate_random_files /generate_random_files
RUN chmod +x /generate_random_files

ADD nodes.txt /nodes.txt
ADD jupiter_config.ini /jupiter_config.ini

ADD simulation/data_sources/start_home.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /

# tell the port number the container should expose
EXPOSE 22 8888

# run the command
CMD ["./start.sh"]
