FROM jekyll/jekyll:3.8.6
LABEL maintainer="https://github.com/saferwall"
LABEL version="0.0.3"
LABEL description="Saferwall Jekyll website: about.saferwall.com"

# Set the Current Working Directory inside the container
WORKDIR /website

# Copy Gemfile and Gemfile.lock files
COPY Gemfile Gemfile.lock ./

# Download all dependencies. Dependencies will be cached if the Gemfile and Gemfile.lock files are not changed
RUN gem install bundler -v 2.1.2
RUN touch Gemfile.lock
RUN chmod a+w Gemfile.lock
RUN bundle install

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Serve it
RUN chmod -R o+w /website
EXPOSE 4000
ENTRYPOINT ["bundle", "exec" , "jekyll", "serve", "--host", "0.0.0.0"]