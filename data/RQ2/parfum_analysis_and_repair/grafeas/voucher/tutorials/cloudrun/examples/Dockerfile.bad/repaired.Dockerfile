# Debian9 image from Jun 8th, 2020
FROM gcr.io/google-appengine/debian9@sha256:023748401f33e710de6297c7e7dd1617f3c3654819885c5208e9df4d0697848e

# Just so the built image is always unique
RUN apt-get update && apt-get -y --no-install-recommends install uuid-runtime && uuidgen > /IAMUNIQUE && rm -rf /var/lib/apt/lists/*;