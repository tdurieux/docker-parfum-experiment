# The clyde service
FROM java:8
LABEL description="Blinky, Inky, Pinky and Clyde"
RUN mkdir -p /usr/local/lib/ghost
ADD target/cn-ghost.jar /usr/local/lib/ghost/ghost.jar
# These are case sensitive. Nice suprise there.