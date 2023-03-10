FROM openjdk:11
ENV SBT_VERSION=1.5.0

#
# Docker file to build a scala app
# based on Scalismo and run the container
# from c++ at runtime
#
# Offline:
# - docker build --no-cache -t my_ssm_app_cli
# Runtime:
# - docker run --name my_ssm_app_cli_container
#              --rm --mount src=/data/my_ssm_app_data,target=/usr/local/data,type=bind my_ssm_app_cli
#

# Install sbt
RUN \
  mkdir /working/ && \
  cd /working/ && \
  curl -f -L -o sbt-$SBT_VERSION.deb https://scala.jfrog.io/artifactory/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install -y --no-install-recommends sbt && \
  sbt sbtVersion && rm -rf /var/lib/apt/lists/*;

#RUN apt-cache search libXxf86vm
RUN apt-get install --no-install-recommends -y libjogl2-java libxt-dev libxtst-dev libgl1-mesa-glx libsm-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-6 libxxf86vm-dev libxrender-dev libxext6 && rm -rf /var/lib/apt/lists/*;

WORKDIR /MyApplication

# Example:

# Copy of MyApplication scala app
# COPY . /MyApplication

# Compilation
# RUN sbt compile

# Call executing the application at runtime
# CMD ["bash", "runMyApplication.sh"]
