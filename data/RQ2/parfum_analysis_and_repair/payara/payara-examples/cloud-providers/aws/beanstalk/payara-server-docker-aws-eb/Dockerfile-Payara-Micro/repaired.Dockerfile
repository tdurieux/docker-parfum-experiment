FROM payara/micro

EXPOSE 8080

CMD ["deployments/application.war", "--contextroot", "/"]

COPY target/application.war $DEPLOY_DIR