FROM launcher.gcr.io/google/jenkins2

USER root

# This fixes an issue with jenkins not being able to draw charts
RUN sed -i 's/^assistive_technologies=/#&/' /etc/java-8-openjdk/accessibility.properties

USER jenkins