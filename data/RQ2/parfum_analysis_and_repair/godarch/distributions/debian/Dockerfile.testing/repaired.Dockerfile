FROM scratch

ADD root.testing.x86_64.tar.gz /

RUN apt-get update && apt-get upgrade -y

# Some common packages
RUN apt-get -y --no-install-recommends install lvm2 && rm -rf /var/lib/apt/lists/*;

ADD helpers/darch-extract /darch-extract
ADD helpers/darch-prepare /darch-prepare
ADD helpers/darch-runrecipe /darch-runrecipe
ADD helpers/darch-teardown /darch-teardown

# Add the Darch repo for initramfs tools.
RUN apt-get -y --no-install-recommends install curl gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://raw.githubusercontent.com/godarch/debian-repo/master/key.pub | apt-key add -
RUN add-apt-repository 'deb https://raw.githubusercontent.com/godarch/debian-repo/master/darch testing main'
RUN apt-get update
RUN apt-get -y --no-install-recommends install darch-initramfs-tools && rm -rf /var/lib/apt/lists/*;
RUN update-initramfs -u

# Clean up
RUN apt-get clean
