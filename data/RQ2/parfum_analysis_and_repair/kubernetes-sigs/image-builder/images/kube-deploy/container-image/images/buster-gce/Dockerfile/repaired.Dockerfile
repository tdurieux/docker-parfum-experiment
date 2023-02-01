FROM buster-base

# Grow disk to fill available space
RUN apt-get install --no-install-recommends --yes cloud-initramfs-growroot && rm -rf /var/lib/apt/lists/*;


# Add google cloud engine debian package repository
RUN apt-get install --no-install-recommends --yes gnupg && rm -rf /var/lib/apt/lists/*;
ADD google-cloud.list /etc/apt/sources.list.d/
# gpg key sourced from https://packages.cloud.google.com/apt/doc/apt-key.gpg
ADD apt-key.gpg /
RUN cat /apt-key.gpg | sudo apt-key add -
RUN rm /apt-key.gpg


# Install critical packages
RUN apt-get update
RUN apt-get install --no-install-recommends --yes google-cloud-packages-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes google-compute-engine && rm -rf /var/lib/apt/lists/*;
# Expand root disk to fill available space
RUN apt-get install --no-install-recommends --yes gce-disk-expand && rm -rf /var/lib/apt/lists/*;
