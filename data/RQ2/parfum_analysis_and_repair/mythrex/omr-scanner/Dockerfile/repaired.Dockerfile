FROM conda/miniconda3

# Various Python and C/build deps
RUN conda install opencv

# install python depencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir imutils

# install NODE
RUN apt-get update -yqq
RUN apt-get install --no-install-recommends curl build-essential -yqq && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --no-install-recommends -yqq nodejs && rm -rf /var/lib/apt/lists/*;

# change working dir for app
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app/

# copy package.json
COPY package*.json /usr/src/app/

# install npm packages
RUN npm install && npm cache clean --force;
RUN npm i -g nodemon && npm cache clean --force;

# copy everything
COPY . /usr/src/app/

# expose the port
EXPOSE 3000
CMD [ "npm", "run", "start" ]
