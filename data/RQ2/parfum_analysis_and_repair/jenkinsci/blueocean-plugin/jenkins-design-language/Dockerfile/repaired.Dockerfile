FROM node:5.11.1

RUN apt-get update && apt-get install --no-install-recommends -y libelf1 && rm -rf /var/lib/apt/lists/*;

RUN useradd jenkins --shell /bin/bash --create-home
USER jenkins
