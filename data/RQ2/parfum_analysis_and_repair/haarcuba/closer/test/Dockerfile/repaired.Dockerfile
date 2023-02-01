FROM haarcuba/ubuntu_ssh
LABEL Description="an ssh container with closer installed for testing" Author="Yoav Kleinberger" Email="haarcuba@gmail.com" Version="1.0"

RUN sudo pip3 install --no-cache-dir closer
RUN sudo pip install --no-cache-dir closer
