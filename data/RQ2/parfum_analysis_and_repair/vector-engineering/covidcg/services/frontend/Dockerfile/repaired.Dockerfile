# --------------------
# FOR DEVELOPMENT ONLY
# --------------------

FROM node:12-alpine

ARG CONFIGFILE

WORKDIR /app

# We need to manually add all the files on the root,
# since we're only mounting the src/ folder as a bind
# volume.
#
# Why not just mount the entire project directory?
#
# We only want to do the npm install at build-time,
# and volume mounting is not done at build-time but at
# run-time. So in order to run `npm install` prior to
# run-time, we have to move all the required files for
# the install over here first

# Add root files