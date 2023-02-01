FROM node:8

# Install gem sass for  grunt-contrib-sass
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN gem install sass

WORKDIR /home/mean

# Install Mean.JS Prerequisites
RUN npm install -g gulp && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;

# Install Mean.JS packages
ADD package.json /home/mean/package.json
RUN npm install && npm cache clean --force;

# Manually trigger bower. Why doesnt this work via npm install?
ADD .bowerrc /home/mean/.bowerrc
ADD bower.json /home/mean/bower.json
RUN bower install --config.interactive=false --allow-root

# Make everything available for start
ADD . /home/mean

# Set development environment as default
ENV NODE_ENV development

# Port 3000 for server
# Port 35729 for livereload
EXPOSE 3000 35729
CMD ["gulp"]
