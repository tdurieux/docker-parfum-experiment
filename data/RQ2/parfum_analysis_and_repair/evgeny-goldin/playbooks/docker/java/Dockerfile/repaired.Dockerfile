# https://registry.hub.docker.com/u/evgenyg/java/

FROM evgenyg/ansible
ADD  playbooks /playbooks
# java_distribution = oracle_jre, oracle_jdk, open_jdk