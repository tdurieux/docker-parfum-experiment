prod.Dockerfile:
  env: production
  packages: postgres
  run_instructions: |
    EXPOSE 80
    ENTRYPOINT prod.sh

dev.Dockerfile:
  env: development
  packages: sqlite
  run_instructions: |
    EXPOSE 3000
    ENTRYPOINT puma -b 0.0.0.0

---
FROM ruby:%{version}
ENV RAILS_ENV %{env}
RUN apt install -y --no-install-recommends bash curl %{packages} && rm -rf /var/lib/apt/lists/*;
%{run_instructions}
