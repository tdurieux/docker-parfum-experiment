FROM phusion/baseimage:0.9.18
RUN apt-get update

# Enable SSH
RUN rm -f /etc/service/sshd/down

# Create auth.log required by fail2ban.
RUN touch /var/log/auth.log

# Install Ansible
RUN apt-get install --no-install-recommends -y software-properties-common git && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update
RUN apt-get install --no-install-recommends -y ansible && rm -rf /var/lib/apt/lists/*;

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
