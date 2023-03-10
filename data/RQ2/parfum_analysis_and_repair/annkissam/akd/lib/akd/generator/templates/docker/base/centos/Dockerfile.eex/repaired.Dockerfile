FROM centos:centos<%= @osversion %>

WORKDIR ~

# Update the system
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y update && yum -y upgrade

# Install Dev tools
RUN yum -y install gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git && rm -rf /var/cache/yum
RUN yum -y install wxBase.x86_64 && rm -rf /var/cache/yum

# wget is a tool that can retrieve files using http, https, and ftp
RUN yum -y install wget && rm -rf /var/cache/yum

# Install Git
RUN yum -y install git && rm -rf /var/cache/yum

# Fetch and install asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v<%= @asdf %>
RUN echo -e '\n. ~/.asdf/asdf.sh' >> ~/.bashrc
RUN echo -e '\n. ~/.asdf/completions/asdf.bash' >> ~/.bashrc
ENV PATH ~/.asdf/bin:$PATH

# Reload configurations
RUN source ~/.bashrc

# Add asdf plugins for elixir and erlang
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
RUN asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git

# Set the locale(en_US.UTF-7)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# For wx Widgets of Erlang
RUN yum -y install wxGTK-devel && rm -rf /var/cache/yum
RUN yum -y install wxBase && rm -rf /var/cache/yum

# Install OTP <%= @erlang %>
RUN asdf install erlang <%= @erlang %>

# Install Unzip for asdf-elixir
RUN yum -y install unzip && rm -rf /var/cache/yum

# Install Elixir <%= @elixir %>
RUN asdf install elixir <%= @elixir %>

ENV PATH ~/.asdf/bin:~/.asdf/shims:$PATH

# Set versions for Elixir and Erlang
RUN asdf global elixir <%= @elixir %>
RUN asdf global erlang <%= @erlang %>

RUN compgen -c

RUN elixir -v

# Get asdf completions + shims
RUN chmod +x ~/.asdf/asdf.sh
RUN chmod +x ~/.asdf/completions/asdf.bash
RUN ~/.asdf/asdf.sh
RUN ~/.asdf/completions/asdf.bash

# This is necessary for whatever reason
RUN ln -s ~/.asdf/shims/elixir /usr/bin/elixir
RUN ln -s ~/.asdf/shims/erlang /usr/bin/erlang

# Install Hex
RUN mix local.hex --force

# Install Rebar
RUN mix local.rebar --force
<%= if @nodejs do %>
# Install Node.js
RUN wget https://nodejs.org/dist/v <%= @nodejs % >/node-v <%= @nodejs % >-linux-x64.tar.gz
RUN tar --strip-components 1 -xzvf node-v* -C /usr/local
RUN node --version
<% end %>
