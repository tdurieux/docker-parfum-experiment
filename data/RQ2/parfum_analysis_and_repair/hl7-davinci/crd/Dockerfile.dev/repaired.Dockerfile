# Base image
 FROM gradle:6.9.0-jdk11
 # Copy app files to container
 COPY --chown=gradle:gradle . /CRD/
 # Set working directory so that all subsequent command runs in this folder
 WORKDIR /CRD
 # Embed CDS Library
 # RUN gradle embedCdsLibrary
 RUN gradle build
 # Expose port to access the app
 EXPOSE 8090
 EXPOSE 8091
 # Command to run our app