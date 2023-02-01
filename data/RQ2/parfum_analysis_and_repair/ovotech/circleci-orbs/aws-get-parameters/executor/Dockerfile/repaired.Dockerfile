FROM circleci/python:3-stretch

RUN sudo pip install --no-cache-dir awscli --upgrade
