This directory contains Dockerfiles to create new Docker images for
running Checker Framework tests reproducibly.

The rest of this file explains how to build new Docker images:


Preliminaries:

  # Finish docker setup if necessary.
  sudo usermod -aG docker $(whoami)
  # Then log out and back in.

  # Obtain Docker credentials.
  # (This is only necessary once per machine; credentials are cached.)
  docker login


Create the Docker image:

# Alias to create the Docker image, in an empty directory, and upload to Docker Hub.
# Takes about 12 minutes for jdk8 or jdk11, about 1 hour for jdk8-plus or jdk11-plus.
alias create_upload_docker_image=' \
  rm -rf dockerdir && \
  mkdir -p dockerdir && \
  (cd dockerdir && \
  \cp -pf ../Dockerfile-$OS-$JDKVER Dockerfile && \
  docker build -t mdernst/$PROJECT-$OS-$JDKVER . && \
  docker push mdernst/$PROJECT-$OS-$JDKVER) && \
  rm -rf dockerdir'

export OS=ubuntu
export JDKVER=jdk8
export PROJECT=cf
create_upload_docker_image

export OS=ubuntu
export JDKVER=jdk8-plus
export PROJECT=cf
create_upload_docker_image

export OS=ubuntu
export JDKVER=jdk11
export PROJECT=cf
create_upload_docker_image

export OS=ubuntu
export JDKVER=jdk11-plus
export PROJECT=cf
create_upload_docker_image

export OS=ubuntu
export JDKVER=jdk17
export PROJECT=cf
create_upload_docker_image

export OS=ubuntu
export JDKVER=jdk17-plus
export PROJECT=cf
create_upload_docker_image


Cleanup:

After creating docker images, consider deleting the docker containers,
which can take up a lot of disk space.
To stop and remove/delete all docker containers:
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
or you can just remove some of them.