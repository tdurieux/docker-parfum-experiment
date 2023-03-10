FROM rock88/moonlight-nx-build:latest

# Add non-privileged build user
RUN useradd -m -s /bin/bash -G sudo build; passwd -d build

# Install fakeroot and updated git
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list &&\
    apt-get update && \
    apt-get -t stretch-backports --no-install-recommends -y install git fakeroot && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/bin/bash"]
