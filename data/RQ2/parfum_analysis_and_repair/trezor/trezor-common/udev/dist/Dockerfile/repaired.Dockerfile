# initialize from the image

FROM fedora:25

# update package repositories

RUN dnf update -y

# install tools

RUN dnf install -y cmake make wget
RUN dnf install -y gcc gcc-c++ git make patchutils pkgconfig wget

# install dependencies for Linux packaging