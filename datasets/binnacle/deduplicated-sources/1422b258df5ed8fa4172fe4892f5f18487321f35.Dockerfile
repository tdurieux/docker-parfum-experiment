FROM jenkinsci/blueocean:latest

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

# Run this command to build the image locally:
## docker image build --no-cache --tag shazchaudhry/docker-jenkins:latest --build-arg GIT_COMMIT=$(git log -1 --format=%H) .
# Once the image has been build using the above command then run this command below to find git commit:
## docker inspect shazchaudhry/docker-jenkins:latest | jq '.[].ContainerConfig.Labels'

# Configure Jenkins
COPY config/*.xml $JENKINS_HOME/
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

# Once jenkins is running and configured, run the following command to find the list of plugins installed:
##  curl -s -k "http://admin:admin@node1/jenkins/pluginManager/api/json?depth=1" | jq -r '.plugins[].shortName' | tee plugins.txt
RUN /usr/local/bin/install-plugins.sh \
  ace-editor \
  ant \
  antisamy-markup-formatter \
  authentication-tokens \
	blueocean \
  blueocean-autofavorite \
  blueocean-commons \
  blueocean-config \
  blueocean-dashboard \
  blueocean-display-url \
  blueocean-events \
  blueocean-github-pipeline \
  blueocean-git-pipeline \
  blueocean-i18n \
  blueocean-jwt \
  blueocean-personalization \
  blueocean-pipeline-api-impl \
  blueocean-pipeline-editor \
  blueocean-pipeline-scm-api \
  blueocean-rest \
  blueocean-rest-impl \
  blueocean-web \
  bouncycastle-api \
  branch-api \
  build-timeout \
  cloudbees-folder \
  credentials \
  credentials-binding \
  display-url-api \
  docker-commons \
  docker-workflow \
  durable-task \
  email-ext \
  external-monitor-job \
  favorite \
  git \
  git-client \
  github \
  github-api \
  github-branch-source \
  gitlab-plugin \
  git-server \
  global-build-stats \
  gradle \
  handlebars \
  icon-shim \
  jackson2-api \
  jquery-detached \
  junit \
  keycloak \
  ldap \
  mailer \
  mapdb-api \
  matrix-auth \
  matrix-project \
  metrics \
  momentjs \
  pam-auth \
  pipeline-build-step \
  pipeline-github-lib \
  pipeline-graph-analysis \
  pipeline-input-step \
  pipeline-milestone-step \
  pipeline-model-api \
  pipeline-model-declarative-agent \
  pipeline-model-definition \
  pipeline-model-extensions \
  pipeline-rest-api \
  pipeline-stage-step \
  pipeline-stage-tags-metadata \
  pipeline-stage-view \
  plain-credentials \
  pubsub-light \
  purge-job-history \
  resource-disposer \
  role-strategy \
  scm-api \
  script-security \
  sse-gateway \
  ssh-credentials \
  ssh-slaves \
  structs \
  subversion \
  swarm \
  timestamper \
  token-macro \
  variant \
  windows-slaves \
  workflow-aggregator \
  workflow-api \
  workflow-basic-steps \
  workflow-cps \
  workflow-cps-global-lib \
  workflow-durable-task-step \
  workflow-job \
  workflow-multibranch \
  workflow-scm-step \
  workflow-step-api \
  workflow-support \
  ws-cleanup
