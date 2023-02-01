# This is a base Docker image used in prod/sandbox/preview Jenkinsfile
FROM artifactory.wikia-inc.com/sus/php-wikia-base:0b02db1c1f7

ADD app /usr/wikia/slot1/current/src
ADD config /usr/wikia/slot1/current/config

# WIKIA_ENVIRONMENT and WIKIA_DATACENTER - needed for maintenance scripts to run, but they are not used by rebuildLocalisationCache.php