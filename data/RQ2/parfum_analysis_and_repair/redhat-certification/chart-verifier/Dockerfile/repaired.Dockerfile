#
# The golang:1.15 image is a copy of docker.io/library/golang:1.17 hosted in Quay to work around rate limits to
# Dockerhub:
#
# > docker pull golang:1.17.2
# > docker tag golang:1.17.2 quay.io/redhat-certification/golang:1.17.2
# > docker push quay.io/redhat-certification/golang:1.17.2
#
# To upgrade Go, then a new image should be pushed to Quay and updated below.
#