# Distro
FROM ubuntu:bionic
MAINTAINER Hazen Babcock <hbabcock@mac.com>

# Update sources
RUN apt update

# Get dependencies
RUN apt-get --yes --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

# Make directories for nginx.
RUN mkdir /var/www/html/brigl

# Get current brigl & install.
RUN git clone https://github.com/HazenBabcock/brigl.git
WORKDIR /brigl
RUN cp -r web/* /var/www/html/brigl/.

# Download parts & install.
WORKDIR /
RUN wget https://www.ldraw.org/library/updates/complete.zip
RUN unzip complete.zip > foo1.txt
RUN python3 /brigl/tools/prepareParts.py /ldraw/parts /var/www/html/brigl/parts > foo2.txt
RUN python3 /brigl/tools/prepareParts.py /ldraw/p /var/www/html/brigl/parts > foo3.txt

# Set owner.
RUN chown -R www-data:www-data /var/www/html/.

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

