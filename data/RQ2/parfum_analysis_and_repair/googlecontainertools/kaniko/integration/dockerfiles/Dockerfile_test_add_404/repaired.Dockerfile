FROM debian:9.11

# Testing that any HTTP failure is handled properly
ADD https://httpstat.us/404 .