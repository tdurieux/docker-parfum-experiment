from ubuntu:14.04

run apt-get update -y
run apt-get install --no-install-recommends -y mercurial && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y bzr && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y httpie && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y strace && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y diffstat && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y tcpdump && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
run pip install --no-cache-dir virtualenv
run apt-get install --no-install-recommends -y virtualenvwrapper && rm -rf /var/lib/apt/lists/*;

# Install go
run curl -f https://storage.googleapis.com/golang/go1.3beta2.linux-amd64.tar.gz | tar -C /usr/local -zx
env GOROOT /usr/local/go
env PATH /usr/local/go/bin:$PATH

# Setup home environment
run useradd dev
run mkdir /home/dev && chown -R dev: /home/dev
run mkdir -p /home/dev/go /home/dev/bin /home/dev/lib /home/dev/include
env PATH /home/dev/bin:$PATH
env PKG_CONFIG_PATH /home/dev/lib/pkgconfig
env LD_LIBRARY_PATH /home/dev/lib
env GOPATH /home/dev/go

run mkdir /var/shared/
run touch /var/shared/placeholder
run chown -R dev:dev /var/shared
volume /var/shared

workdir /home/dev
env HOME /home/dev
add . /home/dev/dotfiles
run make -C /home/dev/dotfiles dockerenv
run ln -s /var/shared/.ssh

run chown -R dev: /home/dev
user dev

entrypoint ["/bin/zsh", "-l"]
