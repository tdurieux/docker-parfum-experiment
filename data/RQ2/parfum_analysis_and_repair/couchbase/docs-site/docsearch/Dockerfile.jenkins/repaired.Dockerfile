# Extends the official Algolia docsearch-scraper image so it can be used with
# Jenkins. It's used by the docsearch-scraper CI job, which is configured in the
# adjacent Jenkinsfile.
FROM algolia/docsearch-scraper:v1.12.0

ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g $GROUP_ID jenkins && \
    useradd -u $USER_ID -g $GROUP_ID -d /docsearch -M jenkins && \
    curl -f -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    mkdir /docsearch && \
    cp /root/Pipfile* /docsearch/ && \
    cp -r /root/src /docsearch/ && \
    find /docsearch -exec chown jenkins:jenkins {} \; && \
    find /docsearch -type d -exec chmod 755 {} \; && \
    find /docsearch -type f -exec chmod 644 {} \; && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "" ]
