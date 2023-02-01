FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://releases.hashicorp.com/vagrant/1.9.3/vagrant_1.9.3_x86_64.deb
RUN dpkg -i vagrant_1.9.3_x86_64.deb
RUN rm vagrant_1.9.3_x86_64.deb
RUN vagrant plugin install vagrant-digitalocean
RUN apt-get install --no-install-recommends -y ruby bundler rsync openssh-client git && rm -rf /var/lib/apt/lists/*;

