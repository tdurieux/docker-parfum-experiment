FROM haskell:7.8

# install vim tooling
RUN apt-get update \
 && apt-get install --no-install-recommends -y git vim curl wget build-essential \
      # for vim extensions
      exuberant-ctags libcurl4-openssl-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# install stack
RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/debian/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/debian/jessie stable main'| tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update \
 && apt-get install --no-install-recommends -y stack \
 && apt-get install --no-install-recommends -y sudo \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Haskell Vim setup
ADD https://raw.githubusercontent.com/begriffs/haskell-vim-now/master/install.sh /install.sh
RUN /bin/bash /install.sh
