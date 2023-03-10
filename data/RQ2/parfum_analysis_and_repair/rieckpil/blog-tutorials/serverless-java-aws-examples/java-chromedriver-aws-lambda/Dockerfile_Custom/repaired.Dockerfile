FROM openjdk:11.0-jre

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y xvfb wget unzip libxi6 libgconf-2-4 && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN CHROME_DRIVER_VERSION=$( curl -f -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

RUN mkdir -p /function && mkdir -p /.local/share/applications && touch /.local/share/applications/mimeapps.list

RUN rm /dev/fd && ln -s /proc/self/fd /dev/fd

COPY target/dependency/* /function/
COPY target/java-chromedriver-aws-lambda.jar /function

ENTRYPOINT [ "/usr/local/openjdk-11/bin/java", "-cp", "/function/*", "com.amazonaws.services.lambda.runtime.api.client.AWSLambda" ]
CMD ["de.rieckpil.blog.InvokeWebDriver::handleRequest"]
