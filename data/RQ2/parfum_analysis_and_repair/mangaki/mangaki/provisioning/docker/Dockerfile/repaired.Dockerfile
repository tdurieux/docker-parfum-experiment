FROM circleci/python:3.7.7-stretch-browsers

RUN sudo pip install --upgrade pip
RUN sudo pip install --no-cache-dir ansible
RUN sudo pip install --no-cache-dir poetry
RUN mkdir -p ~/.ssh
RUN ssh-keyscan beta.mangaki.fr >> ~/.ssh/known_hosts
