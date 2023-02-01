# Use the existing object detection image
FROM ghcr.io/roborregos/robocup-home:objdetection

LABEL maintainer="Jose Cisneros <A01283070@itesm.mx>"

# Change Workdir
WORKDIR /catkin_home

# catkin_make