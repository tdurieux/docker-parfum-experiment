FROM node:latest

# Update aptitude with new repo
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*; # Install software


# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa

# Protect key
RUN chmod 600 /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add gitlab key
RUN ssh-keyscan gitlab.com >> /root/.ssh/known_hosts

# install server to serve static files
RUN npm install -g serve && npm cache clean --force;

# Clone the conf files into the docker container
#RUN git clone git@gitlab.com:ethereum-tcr/ethereum-tcr-ui.git

WORKDIR /ethereum-tcr-ui

ADD . /ethereum-tcr-ui

COPY _DIR/secrets.json /ethereum-tcr-ui/src

RUN npm install && npm cache clean --force;
RUN npm run build

EXPOSE _PORT
CMD serve -p _PORT -s build
