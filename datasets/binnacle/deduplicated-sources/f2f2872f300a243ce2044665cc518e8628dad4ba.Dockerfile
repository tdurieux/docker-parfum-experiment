FROM ubuntu:16.04

RUN apt-get -y update && \
    apt-get install -y curl git-core xz-utils build-essential wget unzip sudo gnupg2 dirmngr

# Add "rvm" as system group, to avoid conflicts with host GIDs typically starting with 1000
RUN groupadd -r rvm && useradd -r -g rvm -G sudo -p "" --create-home rvm && \
    echo "source /etc/profile.d/rvm.sh" >> /etc/rubybashrc
USER rvm

# install rvm, RVM 1.26.0+ has signed releases, source rvm for usage outside of package scripts
RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    (curl -L http://get.rvm.io | sudo bash -s stable) && \
    bash -c " \
        source /etc/rubybashrc && \
        rvmsudo rvm cleanup all "

# Import patch files for ruby and gems
COPY build/patches /home/rvm/patches/
ENV BASH_ENV /etc/rubybashrc

# install rubies and fix permissions on
RUN bash -c " \
    export CFLAGS='-s -O3 -fno-fast-math -fPIC' && \
    for v in 2.5.3 ; do \
        rvm install \$v --patch \$(echo ~/patches/ruby-\$v/* | tr ' ' ','); \
    done && \
    rvm cleanup all && \
    find /usr/local/rvm -type d -print0 | sudo xargs -0 chmod g+sw "

# Install rake-compiler and typical gems in all Rubies
# do not generate documentation for gems
RUN echo "gem: --no-ri --no-rdoc" >> ~/.gemrc && \
    bash -c " \
        rvm all do gem install --no-document bundler 'bundler:~>1.16' rake-compiler hoe mini_portile rubygems-tasks mini_portile2 && \
        find /usr/local/rvm -type d -print0 | sudo xargs -0 chmod g+sw "

# Install rake-compiler's cross rubies in global dir instead of /root
RUN sudo mkdir -p /usr/local/rake-compiler && \
    sudo chown rvm.rvm /usr/local/rake-compiler && \
    ln -s /usr/local/rake-compiler ~/.rake-compiler

# Add cross compilers for Windows and Linux
USER root
RUN apt-get -y update && \
    apt-get install -y gcc-mingw-w64-x86-64 gcc-mingw-w64-i686 g++-mingw-w64-x86-64 g++-mingw-w64-i686 \
        gcc-multilib g++-multilib moreutils

# Create dev tools i686-linux-gnu-*
COPY build/mk_i686.rb /root/
RUN bash -c " \
        rvm alias create default 2.5.3 && \
        rvm use default && \
        ruby /root/mk_i686.rb "

USER rvm

# Patch rake-compiler to build and install static libraries for Linux rubies
RUN cd /usr/local/rvm/gems/ruby-2.5.3/gems/rake-compiler-1.0.7 && \
    ( git apply /home/rvm/patches/rake-compiler-1.0.7/*.diff || true )

ENV XRUBIES 2.6.0 2.5.0 2.4.0 2.3.0 2.2.2

# First do downloads sequentially since they can not run in parallel
# Then build all xruby versions in parallel
# Then cleanup all build artifacts
RUN for rv in $XRUBIES; do \
        bash -c "rake-compiler /home/rvm/.rake-compiler/sources/ruby-$rv/Makefile.in VERSION=$rv HOST=x86_64-linux-gnu"; \
    done; \
    for rv in $XRUBIES; do \
        for host in i686-linux-gnu x86_64-linux-gnu i686-w64-mingw32 x86_64-w64-mingw32; do \
            echo -n "'rake-compiler cross-ruby VERSION=$rv HOST=$host' " >> ~/xbuild_rubies; \
        done; \
    done && \
    cat ~/xbuild_rubies; \
    bash -c " \
    export CFLAGS='-s -O1 -fno-omit-frame-pointer -fno-fast-math' && \
    parallel -- $( cat ~/xbuild_rubies ) && \
    rm -rf ~/.rake-compiler/builds ~/.rake-compiler/sources && \
    find /usr/local/rvm -type d -print0 | sudo xargs -0 chmod g+sw "

# Avoid linking against libruby shared object.
# See also https://github.com/rake-compiler/rake-compiler-dock/issues/13
RUN find /usr/local/rake-compiler/ruby/*linux*/ -name libruby.so | xargs rm
RUN find /usr/local/rake-compiler/ruby/*linux*/ -name libruby-static.a | while read f ; do cp $f `echo $f | sed s/-static//` ; done
RUN find /usr/local/rake-compiler/ruby/*linux*/ -name libruby.a | while read f ; do ar t $f | xargs ar d $f ; done
RUN find /usr/local/rake-compiler/ruby/*linux*/ -name mkmf.rb | while read f ; do sed -i ':a;N;$!ba;s/TRY_LINK = [^\n]*\n[^\n]*\n[^\n]*LOCAL_LIBS)/& -lruby-static/' $f ; done

# RubyInstaller doesn't install libgcc -> link it static.
RUN find /usr/local/rake-compiler/ruby/*mingw*/ -name rbconfig.rb | while read f ; do sed -i 's/."LDFLAGS". = "/&-static-libgcc /' $f ; done

USER root

# Add more libraries and tools to support cross build
RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get install -y libc6-dev:i386 libudev-dev libudev-dev:i386 cmake

# Fix paths in rake-compiler/config.yml and add rvm and mingw-tools to the global bashrc
RUN sed -i -- "s:/root/.rake-compiler:/usr/local/rake-compiler:g" /usr/local/rake-compiler/config.yml && \
    echo "source /etc/profile.d/rvm.sh" >> /etc/bash.bashrc

# # Install wrappers for strip commands as a workaround for "Protocol error" in boot2docker.
COPY build/strip_wrapper /root/
RUN mv /usr/bin/i686-w64-mingw32-strip /usr/bin/i686-w64-mingw32-strip.bin && \
    mv /usr/bin/x86_64-w64-mingw32-strip /usr/bin/x86_64-w64-mingw32-strip.bin && \
    ln /root/strip_wrapper /usr/bin/i686-w64-mingw32-strip && \
    ln /root/strip_wrapper /usr/bin/x86_64-w64-mingw32-strip

# Install SIGINT forwarder
COPY build/sigfw.c /root/
RUN gcc $HOME/sigfw.c -o /usr/local/bin/sigfw

# Install user mapper
COPY build/runas /usr/local/bin/

# Install sudoers configuration
COPY build/sudoers /etc/sudoers.d/rake-compiler-dock

ENV RUBY_CC_VERSION 2.6.0:2.5.0:2.4.0:2.3.0:2.2.2

CMD bash
