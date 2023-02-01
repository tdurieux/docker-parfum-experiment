MAINTAINER Patrick Thomson <patrick.thomson@reconfigure.io>

RUN apt-get update && apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
