# Copyright 2014 The Perkeep Authors.
# Generic purpose Perkeep image, that builds the server (perkeepd)
# and the command-line clients (pk, pk-put, pk-get, and pk-mount).

# TODO: add the HEIC-supporting imagemagick to this Dockerfile too, in
# some way that's minimally gross and not duplicating
# misc/docker/heiftojpeg's Dockerfile entirely. Not decided best way.
# TODO: likewise, djpeg binary? maybe. https://perkeep.org/issue/1142