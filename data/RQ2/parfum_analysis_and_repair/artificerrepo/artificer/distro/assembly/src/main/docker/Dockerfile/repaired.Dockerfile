# This Dockerfile is purely for development and testing!

FROM jboss/wildfly:9.0.1.Final

RUN $JBOSS_HOME/bin/add-user.sh admin artificer1! --silent

EXPOSE 8787

CMD ["$JBOSS_HOME/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-full.xml", "--debug"]

# These 2 steps are latest as to invalidate as fewer layers as possible with each build