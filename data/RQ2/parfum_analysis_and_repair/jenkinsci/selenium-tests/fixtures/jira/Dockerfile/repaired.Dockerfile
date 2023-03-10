#
# Runs JIRA
#
#    The initial password is 'admin:admin'
#
FROM ubuntu

# base package installation
RUN apt-get install --no-install-recommends -y apt-transport-https && echo "deb https://sdkrepo.atlassian.com/debian/ stable contrib" >> /etc/apt/sources.list && apt-get update && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --allow-unauthenticated openjdk-6-jdk atlassian-plugin-sdk netcat && rm -rf /var/lib/apt/lists/*;

# this will install the whole thing, launches Tomcat,
# asks the user to do Ctrl+C to quit, then it shuts down presumably because it
# fails to read from stdin?
RUN atlas-run-standalone --product jira < /dev/null

# unlike the above command, this launches Tomcat then hangs, because it feeds its own tail
# and so stdin will block
CMD atlas-run-standalone --product jira < /dev/stderr

