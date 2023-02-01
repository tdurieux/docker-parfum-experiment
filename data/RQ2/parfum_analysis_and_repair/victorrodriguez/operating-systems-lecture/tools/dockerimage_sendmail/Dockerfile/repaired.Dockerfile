FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends git-email git -y && rm -rf /var/lib/apt/lists/*;
RUN cpan Authen::SASL MIME::Base64 Net::SMTP::SSL


