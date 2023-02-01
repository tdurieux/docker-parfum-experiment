FROM node:8

RUN apt-get update && apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;

RUN adduser yolo


# Set the working directory
WORKDIR /usr/src/app


ENTRYPOINT ["/bin/bash", "-c", "exec \"${@:0}\";"]
CMD ["npm", "run", "start"]


# First, install dependencies to improve layer caching
COPY package.json /usr/src/app/

RUN npm install && npm cache clean --force;

# Add the code
COPY --chown=yolo:yolo . /usr/src/app





# Run the tests and build, to make sure everything is working nicely
RUN npm run build && npm run test

RUN chown -R yolo:yolo /usr/src/app/
USER yolo
RUN echo "cd" >> /home/yolo/.bashrc
COPY --chown=yolo:yolo challenges /home/yolo/challenges
