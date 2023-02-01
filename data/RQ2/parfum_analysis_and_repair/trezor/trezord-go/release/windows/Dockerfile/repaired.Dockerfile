# initialize from the image

FROM fedora:33

# update package repositories

RUN dnf update -y

# install tools