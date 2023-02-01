FROM node:16

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN cd /app && npm install && npm cache clean --force;

# Run when the container launches
CMD cd /app && npm start

# Make port available to the world outside this container
EXPOSE 80