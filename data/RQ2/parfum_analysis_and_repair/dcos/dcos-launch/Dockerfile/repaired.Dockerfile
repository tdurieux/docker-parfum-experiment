FROM python:3.5
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd
RUN apt-get update && apt-get install --no-install-recommends -y libffi-dev ssh && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir tox
