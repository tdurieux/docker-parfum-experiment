# This Docker file is used to build an image with the xReg library and executables,
# and should be tagged something like xreg-${os_name}-${os_version}

# choose either ubuntu or centos
ARG os_name=ubuntu

# for ubuntu choose 16.04, 18.04, or 20.04
# for centos choose 7 or 8