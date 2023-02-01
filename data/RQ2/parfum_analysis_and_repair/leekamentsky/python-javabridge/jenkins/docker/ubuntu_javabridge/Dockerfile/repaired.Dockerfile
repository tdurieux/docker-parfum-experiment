# Start with Ubuntu and install software that is required for
# installing, testing, and running the javabridge.

FROM ubuntu
MAINTAINER Lee Kamentsky,leek@broadinstitute.org

RUN apt-get update && apt-get install --no-install-recommends -y openjdk-6-jdk python-numpy python-dev python-setuptools python-nose && rm -rf /var/lib/apt/lists/*;
