FROM sapmachine:11

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y maven python3 python3-pip git curl && rm -rf /var/lib/apt/lists/*;

ENV MAVEN_OPTS="-Xmx1G"

RUN useradd -ms /bin/bash jenkinsa -u 1000
RUN useradd -ms /bin/bash jenkinsb -u 1001
RUN useradd -ms /bin/bash jenkinsc -u 1002

RUN pip3 install --no-cache-dir requests
