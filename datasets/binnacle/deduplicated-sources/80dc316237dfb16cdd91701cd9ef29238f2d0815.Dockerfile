FROM jboss/wildfly:10.1.0.Final

MAINTAINER agoncal

LABEL name="Schedule Micro Service (war)"
LABEL description="Schedule Micro Service giving all the details of the schedule"
LABEL version=${project.version}
LABEL url="http://localhost:8080/conference-schedule/api/sessions"
LABEL vendor="@agoncal"

# Setting the Wildfly Admin console (user/pwd admin/admin)
RUN $JBOSS_HOME/bin/add-user.sh admin admin --silent
CMD $JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0

COPY ${project.build.finalName}.war $JBOSS_HOME/standalone/deployments/

