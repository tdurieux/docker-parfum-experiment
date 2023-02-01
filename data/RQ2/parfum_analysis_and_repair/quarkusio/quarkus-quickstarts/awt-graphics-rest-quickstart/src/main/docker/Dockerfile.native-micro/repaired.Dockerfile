####
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# ████████████░▄▄▀█░▄▄█░███░█░▄▄▀█░▄▄▀█░▄▄█████████████
# ████████████░▄▄▀█░▄▄█▄▀░▀▄█░▀▀░█░▀▀▄█░▄▄█████████████
# ████████████░▀▀░█▄▄▄██▄█▄██▄██▄█▄█▄▄█▄▄▄█████████████
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
# Preparing distroless Dockerfile in this fashion is highly
# application specific.
#
# The undermentioned example uses ubi-micro image and manually copies necessary
# libraries and files from ubi-minimal image.
#
# See https://www.redhat.com/en/blog/introduction-ubi-micro on how to start using Buildah.
#
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
# This Dockerfile is used in order to build a distroless container that runs the Quarkus application in native (no JVM) mode
#
# Before building the container image run:
#
# ./mvnw package -Pnative -Dquarkus.native.container-build=true -Dquarkus.native.builder-image=quay.io/quarkus/ubi-quarkus-mandrel:21.3-java11
#
# The previous step produces an executable compatible with ubi-minimal.
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native-micro -t quarkus/awt-graphics-rest-micro .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/awt-graphics-rest-micro
#
###