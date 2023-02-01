# basic setup
FROM python:3.7
RUN apt-get update && apt-get -y update
RUN apt-get install --no-install-recommends -y sudo git npm && rm -rf /var/lib/apt/lists/*;

# Setup user to not run as root
RUN adduser --disabled-password --gecos '' flaml-dev
RUN adduser flaml-dev sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER flaml-dev

# Pull repo
RUN cd /home/flaml-dev && git clone https://github.com/microsoft/FLAML.git
WORKDIR /home/flaml-dev/FLAML

# Install FLAML (Note: extra components can be installed if needed)
RUN sudo pip install --no-cache-dir -e .[test,notebook]

# Install precommit hooks
RUN pre-commit install

# For docs
RUN npm install --global yarn && npm cache clean --force;
RUN pip install --no-cache-dir pydoc-markdown
RUN cd website
RUN yarn install --frozen-lockfile && yarn cache clean;

# override default image starting point
CMD /bin/bash
ENTRYPOINT []
