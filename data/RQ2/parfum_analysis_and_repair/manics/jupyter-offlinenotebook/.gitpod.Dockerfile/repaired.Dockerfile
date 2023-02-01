FROM gitpod/workspace-full:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN sudo apt-get -q update && sudo apt-get install --no-install-recommends -yq firefox-geckodriver && rm -rf /var/lib/apt/lists/*;
