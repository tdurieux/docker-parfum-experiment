FROM gradle:6.5.0-jdk11 as builder

# Install Chrome
RUN apt-get update && apt-get install -y --no-install-recommends \
	gnupg apt-transport-https \
	&& curl -f -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo 'deb https://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y --no-install-recommends \
	google-chrome-stable fontconfig fonts-ipafont-gothic fonts-freefont-ttf \
	&& apt-get purge --auto-remove -y gnupg \
	&& rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

# Build, unit test & lint
WORKDIR /workspace/app
COPY settings.gradle build.gradle ./
COPY src src
COPY ui ui
COPY config config
RUN gradle build jacocoTestReport -x :ui:jar

# Start the application and run tests
CMD bash -c 'gradle bootRun &> /dev/null & \
  echo -n "Waiting for boot to complete " && \
  while ! curl --output /dev/null --silent --head --fail http://localhost:8080; do echo -n "." && sleep 1; done && \
  echo " done!" && \
  gradle -q npm_run_e2eHeadless'

