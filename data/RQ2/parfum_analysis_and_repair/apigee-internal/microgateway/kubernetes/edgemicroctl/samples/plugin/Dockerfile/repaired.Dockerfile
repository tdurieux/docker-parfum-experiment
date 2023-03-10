FROM gcr.io/apigee-microgateway/edgemicro:latest
RUN apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;
COPY plugins.zip /opt/apigee/
RUN chown apigee:apigee /opt/apigee/plugins.zip
RUN su - apigee -c "unzip /opt/apigee/plugins.zip -d /opt/apigee"
EXPOSE 8000
EXPOSE 8443
ENTRYPOINT ["/tmp/entrypoint.sh"]
