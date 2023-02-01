FROM evarga/jenkins-slave
RUN apt-get update -y && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
