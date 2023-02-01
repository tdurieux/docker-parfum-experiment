FROM ruby:2.7
ENV workdir /apps

# Install Taginfo site
RUN apt-get update && apt-get -y --no-install-recommends install \
    curl \
    sqlite3 \
    sqlite3-pcre \
    ruby-passenger \
    libapache2-mod-passenger \
    git && rm -rf /var/lib/apt/lists/*;

# Commit ae5a950f7aa4c0de4e706839619a1dc05fc4450a, at 2021-10-18
RUN git clone https://github.com/taginfo/taginfo.git $workdir/taginfo
WORKDIR $workdir/taginfo
RUN echo "gem 'thin' " >>Gemfile
RUN gem install bundler
RUN bundle install

# Install Taginfo tools
RUN apt-get -y --no-install-recommends install \
    cmake \
    libbz2-dev \
    libexpat1-dev \
    libgd-dev \
    libicu-dev \
    libosmium2-dev \
    libprotozero-dev \
    libsqlite3-dev \
    make \
    zlib1g-dev \
    jq \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

# Other useful packages
RUN apt-get install --no-install-recommends -y \
    git \
    osmium-tool \
    pyosmium \
    rsync \
    tmux \
    zsh && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/taginfo/taginfo-tools.git $workdir/taginfo-tools
WORKDIR $workdir/taginfo-tools
RUN git submodule update --init
RUN  mkdir build && cd build && cmake .. && make

RUN apt-get install --no-install-recommends -y nano vim && rm -rf /var/lib/apt/lists/*;
COPY overwrite_config.py $workdir/
COPY start.sh $workdir/

WORKDIR $workdir/
CMD $workdir/start.sh