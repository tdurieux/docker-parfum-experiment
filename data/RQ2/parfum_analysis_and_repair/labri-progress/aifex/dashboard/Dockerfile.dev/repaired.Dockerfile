FROM node

# install python (needed by npm-gyp)
RUN apt-get update && apt-get install --no-install-recommends python make gcc g++ -y && rm -rf /var/lib/apt/lists/*;

# Set the working directory to /app
WORKDIR /app

RUN mkdir logs


# Copy the current directory contents into the container at /app
COPY *.js /app/
COPY *.json /app/


# Install any needed packages specified in requirements.txt
RUN npm install && npm cache clean --force;

# Install supervisor globally
RUN npm install supervisor -g && npm cache clean --force;


# Run when the container launches
CMD npm run dev

# Make port available to the world outside this container
EXPOSE 80