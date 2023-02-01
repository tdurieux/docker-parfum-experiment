# syntax=docker/dockerfile:1
# call from ocelot repo root with
# docker build --platform linux/arm64 --build-arg OCELOT_COVERALLS_TOKEN=$OCELOT_COVERALLS_TOKEN --build-arg OCELOT_GITHUB_API_KEY=$OCELOT_GITHUB_API_KEY --build-arg OCELOT_COVERALLS_TOKEN=$OCELOT_COVERALLS_TOKEN -f ./docker/Dockerfile.build .
# docker build --platform linux/amd64 --build-arg OCELOT_COVERALLS_TOKEN=$OCELOT_COVERALLS_TOKEN --build-arg OCELOT_GITHUB_API_KEY=$OCELOT_GITHUB_API_KEY --build-arg OCELOT_COVERALLS_TOKEN=$OCELOT_COVERALLS_TOKEN -f ./docker/Dockerfile.build .