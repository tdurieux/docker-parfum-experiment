# Please keep the version in sync with the version used by metasfresh
# Also see https://docs.spring.io/spring-boot/docs/current/reference/html/appendix-dependency-versions.html
FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.3

# Also see https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-dev-mode
ENV discovery.type=single-node

# mitigate CVE-2021-44228 log4j2 vulnerability - http://cve.mitre.org/cgi-bin/cvename.cgi?name=2021-44228