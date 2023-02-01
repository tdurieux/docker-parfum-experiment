FROM rastasheep/ubuntu-sshd:16.04

RUN apt-get update && apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

ADD test_gorgon.pem.pub .

RUN mkdir -p ~/.ssh \
  && cat test_gorgon.pem.pub >> ~/.ssh/authorized_keys
