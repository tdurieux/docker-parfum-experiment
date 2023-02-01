FROM maxogden/docker-adventure-time
RUN apt-get update && apt-get install --no-install-recommends -qy docker.io libncurses5-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install -g docker-run@3.1.0 && npm cache clean --force;
RUN npm install -g --unsafe-perm dat && npm cache clean --force;
RUN npm install -g mafintosh/picture-tube#patch-1 serve json && npm cache clean --force;
RUN mkdir /workshop
ADD welcome.txt /workshop
ADD cat.png /workshop
ADD .bashrc /workshop
