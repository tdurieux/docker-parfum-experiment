# Contains python and circleci prereqs
FROM circleci/python:3.7.5-stretch

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | sudo bash -
RUN sudo apt-get update; sudo apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN sudo npm install --global yarn && npm cache clean --force;

# Install pipenv
RUN sudo pip install --no-cache-dir pipenv
