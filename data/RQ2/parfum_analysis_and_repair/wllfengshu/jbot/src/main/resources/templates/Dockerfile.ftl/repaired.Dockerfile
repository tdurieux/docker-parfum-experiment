# project ${projectName}
FROM registry:5000/jdk8:base
# Expose the API port
EXPOSE 8080
ADD target /home/listen/Apps/
ADD startup.sh /home/listen/Apps/
# Run the shell