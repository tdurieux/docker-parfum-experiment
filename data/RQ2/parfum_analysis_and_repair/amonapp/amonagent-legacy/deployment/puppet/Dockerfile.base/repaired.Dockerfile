FROM ubuntu:latest

RUN apt-get install --no-install-recommends -y wget ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
RUN sudo dpkg -i puppetlabs-release-trusty.deb
RUN sudo apt-get update

RUN sudo apt-get install --no-install-recommends -y puppetmaster && rm -rf /var/lib/apt/lists/*;
RUN gem install serverspec