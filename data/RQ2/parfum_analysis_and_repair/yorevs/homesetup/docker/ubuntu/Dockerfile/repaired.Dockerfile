FROM ubuntu

MAINTAINER yorevs

RUN apt-get update && apt-get install --no-install-recommends -y curl locales sudo && rm -rf /var/lib/apt/lists/*;
RUN locale-gen "en_US.UTF-8"
RUN curl -f -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
