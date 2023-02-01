# This Docker file is used to build the xReg distributable executables on linux
# Use a tag like xreg-dist-${os_name}-${os_version} (e.g. xreg-dist-centos-7)

# choose either ubuntu or centos
ARG os_name=ubuntu

# for ubuntu choose 16.04, 18.04, or 20.04
# for centos choose 7 or 8
ARG os_version=16.04

FROM xreg-${os_name}-${os_version}

# need to repeat these due to scope
ARG os_name
ARG os_version

# name of the dist. directory