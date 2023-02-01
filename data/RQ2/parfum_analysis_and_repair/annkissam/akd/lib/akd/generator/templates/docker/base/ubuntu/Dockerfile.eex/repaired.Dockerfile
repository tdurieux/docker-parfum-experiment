FROM ubuntu:<%= @osversion %>

WORKDIR ~

# Update the system
RUN apt -y update && apt -y upgrade
RUN apt-get -y update && apt-get -y upgrade

# wget is a tool that can retrieve files using http, https, and ftp
RUN apt -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

# Install Dev tools
RUN apt-get --fix-missing --no-install-recommends -y install build-essential m4 libncurses5-dev libssh-dev unixodbc-dev libgmp3-dev libwxgtk2.8-dev libglu1-mesa-dev fop xsltproc default-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wxBase.x86_64 && rm -rf /var/lib/apt/lists/*;

# Install Git
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

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

# Other Erlang Dependencies
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install m4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libncurses5-dev && rm -rf /var/lib/apt/lists/*;

# For wx Widgets of Erlang
RUN apt-get -y --no-install-recommends install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3 && rm -rf /var/lib/apt/lists/*;

# More Erlang + wx Related libraries
RUN apt-get -y --no-install-recommends install libssh-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install unixodbc-dev && rm -rf /var/lib/apt/lists/*;

# Install OTP <%= @erlang %>
RUN asdf install erlang <%= @erlang %>

# Install Unzip for asdf-elixir
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

# Install Elixir <%= @elixir %>
RUN asdf install elixir <%= @elixir %>

ENV PATH ~/.asdf/bin:~/.asdf/shims:$PATH

# Set versions for Elixir and Erlang
RUN asdf global elixir <%= @elixir %>
RUN asdf global erlang <%= @erlang %>

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
