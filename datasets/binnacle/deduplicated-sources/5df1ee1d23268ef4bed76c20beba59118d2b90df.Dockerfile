FROM circleci/golang:1.12-node

RUN sudo apt-get update && sudo apt-get install -y libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 xvfb
