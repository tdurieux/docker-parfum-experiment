FROM ruby:3.1.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app

# Start the main process.
CMD ["middleman", "server", "--bind-address", "0.0.0.0"]
