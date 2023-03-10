FROM alpine:latest

# Create a non-root user and group
# -H Don't create home directory
# -D Don't assign a password
# -g GECOS field
# -G Group
RUN set -ex \
  && addgroup kubeletctl \
  && adduser \
    -H \  
    -D \ 
    -g ',,,,' \
    -G kubeletctl \
    kubeletctl \
  && > /var/log/faillog \
  && > /var/log/lastlog


# Use this line if you want to download it while building the image. 
# Make sure to use the most recent release build
RUN wget https://github.com/cyberark/kubeletctl/releases/download/v1.7/kubeletctl_linux_386 && chmod a+x ./kubeletctl_linux_386 && mv ./kubeletctl_linux_386 /usr/local/bin/kubeletctl

# Download the latest release of kubeletctl_linux_386 from https://github.com/cyberark/kubeletctl/releases and then copy the file
#COPY ./kubeletctl_linux_386 /usr/local/bin/kubeletctl 
#RUN chmod a+x /usr/local/bin/kubeletctl

USER kubeletctl