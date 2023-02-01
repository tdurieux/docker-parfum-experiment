FROM sonarqube:7.9.1-community
RUN curl -f -O -L $( curl -f -s https://api.github.com/repos/kwoding/sonar-webdriver-plugin/releases/latest \
| grep browser_download_url \
| cut -d '"' -f 4)
RUN mv sonar-webdriver-plugin-*.jar /opt/sonarqube/extensions/plugins/
