FROM ruby:2.5.3
ENV RAILS_ENV development
RUN apt install -y --no-install-recommends bash curl sqlite && rm -rf /var/lib/apt/lists/*;
EXPOSE 3000
ENTRYPOINT puma -b 0.0.0.0

