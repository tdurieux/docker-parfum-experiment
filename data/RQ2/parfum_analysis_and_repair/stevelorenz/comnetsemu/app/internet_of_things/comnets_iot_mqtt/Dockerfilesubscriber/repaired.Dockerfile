#from the eclipse base image
FROM eclipse-mosquitto:latest
COPY subscribeh3.sh /
#RUN ls