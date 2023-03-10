# Use the previous version of qlik-py-tools as a parent image
FROM nabeeloz/qlik-py-tools:3.5

# Set the working directory to /qlik-py-tools/core
WORKDIR /qlik-py-tools/core

# Copy all files from the core subdirectory into the container
COPY ./core/* /qlik-py-tools/core/

# Copy modified file for skater
COPY ./feature_importance.py /usr/local/lib/python3.6/site-packages/skater-1.1.2-py3.6.egg/skater/core/global_interpretation/

# Make port 80 available to the world outside this container
EXPOSE 80

# Run __main__.py when the container launches