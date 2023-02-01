FROM ruby:2.6

LABEL "com.github.actions.name"="Danger"
LABEL "com.github.actions.description"="Run Danger"
LABEL "com.github.actions.icon"="alert-triangle"
LABEL "com.github.actions.color"="yellow"

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential p7zip unzip && rm -rf /var/lib/apt/lists/*;

RUN gem install danger -v '>= 5.10.3'
RUN gem install danger-checkstyle_format

ENTRYPOINT "danger"
CMD "--verbose"
