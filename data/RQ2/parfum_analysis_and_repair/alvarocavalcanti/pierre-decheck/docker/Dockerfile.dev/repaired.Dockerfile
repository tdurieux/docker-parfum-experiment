FROM python:3.7
ENV PYTHONUNBUFFERED 1

WORKDIR /pierre-decheck

# Install required python packages
COPY requirements.txt /pierre-decheck/
RUN pip install --no-cache-dir -r requirements.txt

# And the dev dependencies
COPY requirements-dev.txt /pierre-decheck/
RUN pip install --no-cache-dir -r requirements-dev.txt

# Setup SSH with secure root login
RUN apt-get update \
 && apt-get install --no-install-recommends -y openssh-server netcat \
 && mkdir /var/run/sshd \
 && echo 'root:password' | chpasswd \
 && sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && rm -rf /var/lib/apt/lists/*;

COPY docker/bashrc.dev /root/.bashrc

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
