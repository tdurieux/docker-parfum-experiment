FROM    dockercore/golang-cross:1.9.4@sha256:b8d43ef11ccaa15bec63a1f1fd0c28a0e729074aa62fcfa51f0a5888f3571315
ENV     DISABLE_WARN_OUTSIDE_CONTAINER=1
WORKDIR /go/src/github.com/docker/cli