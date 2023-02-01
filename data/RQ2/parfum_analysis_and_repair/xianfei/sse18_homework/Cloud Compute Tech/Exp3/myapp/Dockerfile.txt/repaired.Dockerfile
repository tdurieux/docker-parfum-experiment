# Use an official Python runtime as a parent image
FROM node:16

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified with npm
RUN npm install && npm cache clean --force;

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME AnotherWorld

# Run app.py when the container launches
CMD ["node", "server.js"]
