# Image used to generate the Dockerfiles from a Go text template.
#
# Build:
#   docker build --rm --pull -t gcr.io/kaggle-images/go-renderizer -f Dockerfile .
#
# Push:
#   docker push gcr.io/kaggle-images/go-renderizer