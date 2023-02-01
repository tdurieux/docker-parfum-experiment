# Instructions copied from - https://hub.docker.com/_/python/
FROM ubuntu:16.04

RUN apt-get -yqq update
RUN apt-get -yqq --no-install-recommends install python3-pip python3-dev libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-server mongodb && rm -rf /var/lib/apt/lists/*;
ADD circe/pricing_push/requirements.txt /requirements.txt
RUN apt-get -y --no-install-recommends install build-essential libssl-dev libffi-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get install --no-install-recommends -y sshpass nano && rm -rf /var/lib/apt/lists/*;

# Taken from quynh's network profiler
RUN pip install --no-cache-dir cryptography

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
RUN echo 'root:PASSWORD' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Create the mongodb directories
RUN mkdir -p /mongodb/data
RUN mkdir -p /mongodb/log

# Create the input, output
RUN mkdir -p /input
RUN mkdir -p /output

# Add input files
COPY  app_specific_files/dummy_app_multicast/sample_input /sample_input

# Add the mongodb scripts
ADD circe/pricing_push/runtime_profiler_mongodb /central_mongod

ADD circe/pricing_push/readconfig.py /readconfig.py
ADD circe/pricing_push/scheduler.py /scheduler.py
ADD jupiter_config.py /jupiter_config.py
ADD circe/pricing_push/evaluate.py /evaluate.py

# Add the task speficific configuration files
RUN echo app_specific_files/dummy_app_multicast/configuration.txt
ADD app_specific_files/dummy_app_multicast/configuration.txt /configuration.txt
ADD nodes.txt /nodes.txt
ADD jupiter_config.ini /jupiter_config.ini

#ADD circe/pricing_push/monitor.py /centralized_scheduler/monitor.py
ADD circe/pricing_push/start_home.sh /start.sh
RUN chmod +x /start.sh
RUN chmod +x /central_mongod
ADD app_specific_files/dummy_app_multicast/name_convert.txt /centralized_scheduler/name_convert.txt
ADD app_specific_files/dummy_app_multicast/sample_input/1botnet.ipsum /centralized_scheduler/1botnet.ipsum

WORKDIR /

# tell the port number the container should expose
EXPOSE 22 8888

# run the command
CMD ["./start.sh"]
