FROM maven:3.3.9-jdk-8

LABEL Description="Repairnator checkbranch docker image" Vendor="Spirals" Version="0.0.0"

COPY check_branches.sh /root/
COPY repairnator-schema.json /root/

RUN echo "Europe/Paris" > /etc/timezone && chmod +x /root/*.sh
RUN apt-get update
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g ajv-cli && npm cache clean --force;

ENV M2_HOME=$MAVEN_HOME

ENV REPOSITORY=
ENV BRANCH_NAME=
ENV HUMAN_PATCH=

WORKDIR /root
ENTRYPOINT /root/check_branches.sh $REPOSITORY $BRANCH_NAME $HUMAN_PATCH