FROM ubuntu
LABEL description="Security & Quality CodeQL Container Build for Cool Applications"
SHELL ["/bin/bash", "-c"]
ENV TZ=America/New_York

# create directories
RUN mkdir /tools

# setup tools
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install --no-install-recommends -y golang zip wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://github.com/github/codeql-action/releases/download/codeql-bundle-20211005/codeql-bundle-linux64.tar.gz
RUN tar xzf /codeql-bundle-linux64.tar.gz -C tools && rm /codeql-bundle-linux64.tar.gz

# copy source
COPY . /usr/src/myapp

# set working directory
WORKDIR /usr/src/myapp

# example repo used: https://github.com/ghas-bootcamp/ghas-bootcamp

# codeql create
RUN /tools/codeql/codeql database create db --language=javascript, java --db-cluster  --no-run-unnecessary-builds -vvvv

# codeql analyze with default queries
RUN /tools/codeql/codeql database analyze codeql-database/go go-code-scanning.qls --format=sarif-latest --output=codeql-go-results.sarif --sarif-category=goiscool
RUN /tools/codeql/codeql database analyze db javascript-code-scanning.qls --format=sarif-latest --output=codeql-javascript-results.sarif --sarif-category=javascriptiscool

# upload results
# remember to get the MERGE commit for a PR
RUN /tools/codeql/codeql github upload-results --github-url=<ghes-url> --repository=oreos/miniature-invention --ref=refs/pull/1/merge --commit=778337f84a5abe2cda468c7abf6038b8a193cea2 --sarif=codeql-go-results.sarif --github-auth-stdin=<github PAT>
RUN /tools/codeql/codeql github upload-results --github-url=<ghes-url> --repository=oreos/miniature-invention --ref=refs/pull/1/merge --commit=778337f84a5abe2cda468c7abf6038b8a193cea2 --sarif=codeql-javascript-results.sarif --github-auth-stdin=<github PAT>
