# Expected Usage:
#
#   # Get the repo
#   git clone git@github.com:RocketMap/RocketMap.git
#
#   # Go into it
#   cd RocketMap
#
#   # Build the dev container
#   docker build -f Dockerfile.dev -t pgodev .
#
#   # Start the dev container in the background, mounting
#   # this directory over it and port mapping 5000 through
#   docker run -td -v `pwd`:/usr/src/app -p 5000:5000 --name pgd pgodev
#
# Now you can `exec` in as needed and run all the dependency
# install steps, start grunt, and even start an instance,
# like:
#   docker exec -ti pgd npm install
#   docker exec -ti pgd pip install -r requirements.txt --upgrade
#   docker exec -ti pgd grunt
# or even
#   docker exec -ti pgd sh
#   > echo 'its a shell prompt, do whatever'

# Be small, thanks
FROM python:2.7-alpine

# Default location; also where we mount over
WORKDIR /usr/src/app

# The basic command
CMD [ "sh" ]

# basic packages we're using
RUN apk add --no-cache --update ca-certificates build-base nodejs ruby ruby-dev libffi-dev git

# For travis-ci
RUN gem install travis --no-ri --no-rdoc
