# Image to run analytics/refinery jars updater (T210271)
FROM {{ "ci-buster" | image_tag }}

USER root

# Dependencies for analytics/refinery bin/update-refinery-source-jars