ARG IMAGE_REPO
FROM ${IMAGE_REPO:-lagoon}/mariadb-galera

ENV MARIADB_DATABASE=drupal \
    MARIADB_USER=drupal \
    MARIADB_PASSWORD=drupal
