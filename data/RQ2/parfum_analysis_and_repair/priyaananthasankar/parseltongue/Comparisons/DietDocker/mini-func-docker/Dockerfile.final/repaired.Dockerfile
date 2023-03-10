FROM prananth/uruk-hai-wheelhouse:v1
COPY . /home/site/wwwroot

RUN cd /home/site/wwwroot && \
    pip3 install --no-cache-dir -r requirements.txt

# Enable more verbose logging inside container
ENV AZURE_FUNCTIONS_ENVIRONMENT=Development

# Add any other ENV Variables here like AzureWebJobsStorage for Triggers/Bindings etc

EXPOSE 8080 #or whatever port you want to expose
