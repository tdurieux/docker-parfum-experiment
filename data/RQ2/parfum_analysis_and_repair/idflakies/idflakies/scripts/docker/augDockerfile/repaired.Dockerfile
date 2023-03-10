# docker build -t <IMAGE>:latest - < <MODIFIEDSLUG>_Dockerfile

# Start from the tooling image
FROM toolingdetectorbase:latest

WORKDIR /home/idflakies
USER idflakies

# Download the project, checkout the SHA, install the project (with running tests)
RUN \
  /bin/bash -xec 'git clone https://github.com/<SLUG> <SLUG> && cd <SLUG> && git checkout <SHA> && \
  timeout 1h /home/idflakies/apache-maven/bin/mvn clean install -DskipTests -fn -B |& tee /home/idflakies/<SLUG>/mvn-test.log && { time -p timeout 1h /home/idflakies/apache-maven/bin/mvn test  -fn -B |& tee -a /home/idflakies/<SLUG>/mvn-test.log ;} 2> /home/idflakies/<SLUG>/mvn-test-time.log'

# Go back to root as to allow ease of later scripts to copy data back and forth