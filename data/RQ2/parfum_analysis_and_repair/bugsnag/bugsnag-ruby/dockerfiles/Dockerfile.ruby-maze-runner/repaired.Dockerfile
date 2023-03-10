FROM ruby:2.6 as ruby-package-builder

RUN gem install bundler

WORKDIR /app

COPY bugsnag.gemspec Gemfile VERSION ./

RUN bundle install

COPY  CHANGELOG.md CONTRIBUTING.md TESTING.md LICENSE.txt Rakefile README.md UPGRADING.md .gitignore .rspec .rubocop.yml .rubocop_todo.yml .yardopts docker-compose.yml ./
COPY .buildkite ./.buildkite
COPY .git ./.git
COPY .github ./.github
COPY dockerfiles ./dockerfiles
COPY features ./features
COPY lib ./lib
COPY spec ./spec

RUN gem build bugsnag.gemspec

# The maze-runner node tests
FROM 855461928731.dkr.ecr.us-west-1.amazonaws.com/maze-runner-releases:v3.0.2-cli as ruby-maze-runner
WORKDIR /app/
COPY features ./features
COPY --from=ruby-package-builder /app/bugsnag-*.gem bugsnag.gem