FROM $USER/ferry-base
NAME gluster

# Create necessary directories
RUN mkdir -p /service/data /service/logs /service/conf /service/sbin;chown -R ferry:docker /service/data;chown -R ferry:docker /service/logs;chown -R ferry:docker /service/conf

# Add the latest stable GlusterFS repo
RUN apt-get update; apt-get --yes --no-install-recommends install software-properties-common; rm -rf /var/lib/apt/lists/*; add-apt-repository --yes ppa:semiosis/ubuntu-glusterfs-3.5

# Tell apt to use the latest repo packages.
RUN echo "Package: *" >> /etc/apt/preferences
RUN echo "Pin: release o=LP-PPA-semiosis-ubuntu-glusterfs-3.5,a=trusty" >> /etc/apt/preferences
RUN echo "Pin-Priority: 900" >> /etc/apt/preferences

# Download the various packages needed
RUN apt-get update; apt-get --yes --no-install-recommends install git glusterfs-common glusterfs-client glusterfs-server attr && rm -rf /var/lib/apt/lists/*;

# Add the control script to the image.
ADD ./startnode /service/sbin/
RUN chmod a+x /service/sbin/startnode

