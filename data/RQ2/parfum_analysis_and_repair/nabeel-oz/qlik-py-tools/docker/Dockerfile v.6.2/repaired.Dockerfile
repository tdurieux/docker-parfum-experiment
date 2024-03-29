# Use the previous version of qlik-py-tools as a parent image
FROM nabeeloz/qlik-py-tools:6.1

# Set the working directory to /qlik-py-tools/core
WORKDIR /qlik-py-tools/core

# Copy all files from the core subdirectory into the container
COPY ./core/* /qlik-py-tools/core/

# Make ports 80 and 50055 available to the world outside this container
EXPOSE 80 50055

# Run __main__.py when the container launches