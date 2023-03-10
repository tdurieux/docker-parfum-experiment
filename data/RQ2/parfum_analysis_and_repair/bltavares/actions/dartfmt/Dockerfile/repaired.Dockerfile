FROM google/dart:2

LABEL "com.github.actions.name"="dartfmt"
LABEL "com.github.actions.description"="Provides formating and fixes for Dart using dartfmt"
LABEL "com.github.actions.icon"="user-check"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/bltavares/actions"
LABEL "homepage"="http://github.com/bltavares/actions"
LABEL "maintainer"="Bruno Tavares <connect+githubactions@bltavares.com>"

RUN apt-get update -qq && apt-get install -qqy --no-install-recommends \
  curl=7.* \
  jq=1.* \
  bash=4.* \
  git=1:2.* \
  && rm -rf /var/lib/apt/lists/*

COPY lib.sh /lib.sh
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]