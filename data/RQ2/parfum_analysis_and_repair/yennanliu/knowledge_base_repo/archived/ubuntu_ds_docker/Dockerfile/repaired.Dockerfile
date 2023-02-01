FROM ubuntu

# Install Ruby.
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y ruby \
  apt-get install wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get update

# basics
RUN apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

# install homebrew
RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

########## R ##########
RUN mkdir -p /opt
ADD install_R.sh /opt/
RUN chmod +x /opt/install_R.sh
RUN /opt/install_R.sh