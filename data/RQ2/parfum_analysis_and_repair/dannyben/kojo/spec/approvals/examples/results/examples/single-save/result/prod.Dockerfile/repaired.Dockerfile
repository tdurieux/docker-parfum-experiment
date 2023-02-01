FROM ruby:2.5.3
ENV RAILS_ENV production
RUN apt install -y --no-install-recommends bash curl postgres && rm -rf /var/lib/apt/lists/*;
EXPOSE 80
ENTRYPOINT prod.sh

