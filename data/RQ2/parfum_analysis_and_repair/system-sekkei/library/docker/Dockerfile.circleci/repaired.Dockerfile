FROM circleci/openjdk:17-jdk

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y graphviz imagemagick fonts-ipafont && rm -rf /var/lib/apt/lists/*;

