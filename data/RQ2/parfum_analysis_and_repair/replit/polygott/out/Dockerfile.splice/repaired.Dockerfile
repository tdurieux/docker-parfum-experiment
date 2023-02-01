# syntax = docker/dockerfile:1.2@sha256:e2a8561e419ab1ba6b2fe6cbdf49fd92b95912df1cf7d313c3e2230a333fdbcc

# A Dockerfile that can splice multiple independent layers into a single image.


## Final image where the contents of the tarballs are all extracted together.
FROM polygott:phase1.5 AS polygott
#ADD#