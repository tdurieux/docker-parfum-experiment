# This Dockerfile builds a docker image based on ubuntu:18.04, which includes
# additional 70 layers. The image is used in cri-containerd tests and validate
# VPMem multi-mapping and LCOW container layer packing feature
#
# The image is available at cplatpublic.azurecr.io/ubuntu70extra:18.04