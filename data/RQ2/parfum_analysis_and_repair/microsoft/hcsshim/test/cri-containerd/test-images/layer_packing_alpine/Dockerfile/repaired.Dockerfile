# This Dockerfile builds a docker image based on alpine:latest, which includes
# additional 70 layers. The image is used in cri-containerd tests and validate
# VPMem multi-mapping and LCOW container layer packing feature
#
# The image is available at cplatpublic.azurecr.io/alpine70extra:latest