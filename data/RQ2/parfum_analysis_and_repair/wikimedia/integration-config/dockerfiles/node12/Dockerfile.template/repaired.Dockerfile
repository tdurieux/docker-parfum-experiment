# Docker image with plain nodejs and npm.

FROM {{ "ci-bullseye" | image_tag }}

USER root

RUN {{ "nodejs" | apt_install }}

# Pin our Node 12 image to npm 7.x. Official Node.js 12 tarballs come with npm 6,
# but, we upgraded npm and we're sticking to it.