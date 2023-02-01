# Dockerfile for GitHub Actions (unit test)
FROM shinaoka/dcore_dev_triqs3
COPY .github_scripts/entrypoint-examples.sh /
COPY .github_scripts/env-examples.sh /
COPY . /var/dcoretest
RUN ["chmod", "+x", "/entrypoint-examples.sh"]
WORKDIR /var/dcoretest
RUN ["git", "clean", "-xdf"]
#ENTRYPOINT ["/entrypoint-examples.sh"]