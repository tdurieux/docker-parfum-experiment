# This first line selects our base image from Balena repository
FROM balenalib/%%BALENA_MACHINE_NAME%%:latest

# Here we install we install openssh-server with built-in script that makes all the update, install and cleaning for us