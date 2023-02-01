FROM python:2.7

RUN pip install --no-cache-dir ansible-lint==3.4.15

RUN apt-get update && \
    apt install --no-install-recommends -y default-jre && \
    java -version && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y unzip && \
    wget -q -nc https://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip && \
    unzip sonar-runner-dist-2.4.zip && \
    chmod a+x /sonar-runner-2.4/bin/* && \
    rm -f sonar-runner-dist-2.4.zip && rm -rf /var/lib/apt/lists/*;

ENV PATH PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sonar-runner-2.4/bin

ENTRYPOINT /sonar-runner-2.4/bin/sonar-runner