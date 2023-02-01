###############################################################################
FROM node:10.22.1 as ci
###############################################################################

RUN apt-get update

# Set up non-root user ########################################################
# The node container already comes with a "node" user of UID 1000, so we'll
# just use that.

ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Add sudo privileges to non-root user
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

# Install Packages ############################################################

# Install build dependencies
RUN apt-get install --no-install-recommends -y \
    git && rm -rf /var/lib/apt/lists/*;
RUN npm install -g \
    eslint && npm cache clean --force;

# Clone correct version of Kibana
RUN git clone --branch v7.9.2 --depth 1 https://github.com/elastic/kibana /home/$USERNAME/kibana

# Set up plugin directory
RUN mkdir -p /home/$USERNAME/kibana/plugins
RUN chown -R $USER_UID:$USER_GID /home/$USERNAME/kibana

# Install Kibana dependencies
RUN cd /home/$USERNAME/kibana && sudo -u $USERNAME yarn kbn bootstrap && yarn cache clean;

###############################################################################
FROM ci as devcontainer
###############################################################################