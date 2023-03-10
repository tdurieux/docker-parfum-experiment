##### datmo essential ###
# Mount essential folders
VOLUME ["/task", "/data", "/home"]

# Setup environment_driver variables
ENV DATMO_TASK_DIR=/task
ENV DATMO_DATA_DIR=/data

RUN mkdir -p /task/ /home/ /data/

# Setting working directory
# Working directory: this is where unix scripts will run from
WORKDIR /home/

###########################