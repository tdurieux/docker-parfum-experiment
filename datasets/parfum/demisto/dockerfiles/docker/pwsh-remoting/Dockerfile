FROM demisto/powershell-ubuntu:7.1.3.22925

RUN mkdir /root/.ssh
#Supressing the interactive host verification prompt
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config
#Supressing the 'Permanently added '<ssh-host-name>' (ECDSA) to the list of known hosts' warning.
RUN echo "LogLevel ERROR" >> /root/.ssh/config

RUN apt-get update && apt-get install -y --no-install-recommends openssh-client
