FROM jenkins/jenkins
# if we want to install via apt
USER root
RUN apt-get update && apt-get install --no-install-recommends -y maven && ( curl -f -sSL https://get.docker.com/ | sh) && rm -rf /var/lib/apt/lists/*;
# drop back to the regular jenkins user - good practice
USER jenkins