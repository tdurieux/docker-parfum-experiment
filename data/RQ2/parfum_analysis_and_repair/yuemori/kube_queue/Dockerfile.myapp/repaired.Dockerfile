FROM ruby

RUN apt-get update -y && apt-get install -y git --no-install-recommends && rm -r /var/cache/apt /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler:2.0.2

ENV KUBE_QUEUE_PATH /vendor/kube_queue
ENV WORKDIR /app

WORKDIR $WORKDIR

COPY .git $KUBE_QUEUE_PATH/.git
COPY Gemfile kube_queue.gemspec $KUBE_QUEUE_PATH/
COPY exe/kube_queue $KUBE_QUEUE_PATH/exe/kube_queue
COPY lib/kube_queue/version.rb $KUBE_QUEUE_PATH/lib/kube_queue/version.rb
COPY examples/myapp/Gemfile examples/myapp/Gemfile.lock $WORKDIR/
RUN bundle install -j4

COPY lib $KUBE_QUEUE_PATH/lib
COPY template $KUBE_QUEUE_PATH/template
COPY examples/myapp/ $WORKDIR

RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "console"]
