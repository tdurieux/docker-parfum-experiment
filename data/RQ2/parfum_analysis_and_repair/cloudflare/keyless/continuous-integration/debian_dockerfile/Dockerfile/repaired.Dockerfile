#Set the base image to debian
FROM debian
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install wget zip unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rubygems && rm -rf /var/lib/apt/lists/*;
RUN gem install -y fpm
RUN mkdir /root/.ssh/

#copy over private key and set permissions
ADD remote-agent /root/.ssh/remote-agent
RUN chmod 600 /root/.ssh/remote-agent

#create known hosts
RUN touch /root/.ssh/known_hosts
#add key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
