FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y python2.7 python-pip python-dev python3 python3-pip python3-dev build-essential libssl-dev libffi-dev sudo git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir virtualenv 'tox!=2.4.0,>=2.3' jenkinsapi
RUN useradd jenkins --shell /bin/bash --create-home --uid 500
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
