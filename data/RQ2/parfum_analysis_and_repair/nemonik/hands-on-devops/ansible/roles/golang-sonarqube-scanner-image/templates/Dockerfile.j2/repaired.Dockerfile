FROM {{ registry_host }}:{{ registry_port }}/nemonik/golang:{{ golang_version }}
MAINTAINER Michael Joseph Walsh <nemonik@gmail.com>

RUN apt-get -y update && apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

RUN wget -O /usr/local/sonar-scanner-cli-{{ sonar_scanner_cli_version }}-linux.zip --no-check-certificate --no-cookies https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-{{ sonar_scanner_cli_version }}-linux.zip; \
        unzip /usr/local/sonar-scanner-cli-{{ sonar_scanner_cli_version }}-linux.zip -d /usr/local; \
        echo "http://{{ sonarqube_host }}:{{ sonarqube_port }}" > /usr/local/sonar-scanner-{{ sonar_scanner_cli_version }}-linux/conf/sonar-scanner.properties; \
        rm /usr/local/sonar-scanner-cli-{{ sonar_scanner_cli_version }}-linux.zip

ENV PATH /usr/local/sonar-scanner-{{ sonar_scanner_cli_version }}-linux/bin:$PATH
