ARG BASE_IMAGE_TAG=latest

FROM outofcoffee/imposter-base:${BASE_IMAGE_TAG}

LABEL MAINTAINER="Pete Cornish <outofcoffee@gmail.com>"

CMD ["--plugin", "rest", "--configDir", "/opt/imposter/config"]