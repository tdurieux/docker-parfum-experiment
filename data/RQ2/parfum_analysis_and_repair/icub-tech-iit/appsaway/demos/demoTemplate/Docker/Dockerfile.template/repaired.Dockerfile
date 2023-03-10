# Start your docker container from a base image. Generally you will want to start
# with the following: FROM icubteamcode/ubuntu1804mesa:latest

FROM repository/image:tag



LABEL maintainer=" your.email@domain"

# here you can set some environment variables. For example, in most demos you will
# not have an interactive frontend, so you can specify ENV DEBIAN_FRONTEND=noninteractive

ENV ENV_VARIABLE=value



# create a new runtimeusers group
# don't change this unless you know what you are doing

RUN groupadd -K GID_MIN=100 -K GID_MAX=499 runtimeusers



# now you can start the installation of your container. Bear in mind that you are installing in
# the container you have selected as the base, so if you chose our default Ubuntu image, you
# will be installing through a ubuntu shell.

RUN your_commands

# an example for installing libraries in ubuntu:
# RUN apt-get update &&\
#     apt-get install --install-recommends -y \
#         sudo
#         software-properties-common
#         apt-utils
#         etc
#         ...



# you can set or send arguments into the docker file for your image creation. For this, you have
# to initialize a variable with ARG (e.g.: ARG GAZEBO_VER). You can set a default value for this
# variable, which can be overwritten at image-creation time (e.g.: ARG GAZEBO_VER=10).

ARG your_argument=optional_default_value



# you can copy files in the same folder of the Dockerfile into the container. To do so you need to 
# use the COPY command, e.g.: COPY entrypoint.sh /user/local/bin/entrypoint.sh

COPY your_file /path/to/folder/new_file_name



# you can specify an entrypoint file with some commands to be executed when the container is
# launched. To do so you need to specify the entrypoint script

ENTRYPOINT [ "/path/to/file/file_name" ]



# to expose a port from the container, there are two steps to be performed:
# first, you need to define which port to expose by adding EXPOSE port_number/carrier
# a second step requires the container to be ran with the -p (for particular ports) or
# with -P (for all "exposed" ports)

EXPOSE 10000/tcp 10000/udp



# some QT-Apps don't show controls without this

ENV QT_X11_NO_MITSHM 1
ENV YARP_COLORED_OUTPUT 1



# we finish the dockerfile with an instruction to run bash shell