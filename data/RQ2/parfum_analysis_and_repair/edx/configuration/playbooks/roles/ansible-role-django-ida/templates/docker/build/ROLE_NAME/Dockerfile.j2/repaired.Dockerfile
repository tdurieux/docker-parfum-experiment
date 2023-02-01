# To build this Dockerfile:
#
# From the root of configuration:
#
# docker build -f docker/build/{{ role_name|replace("_","-") }}/Dockerfile .
#
# This allows the dockerfile to update /edx/app/edx_ansible/edx_ansible
# with the currently checked-out configuration repo.