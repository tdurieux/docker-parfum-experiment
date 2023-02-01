## This Dockerfile compiles the watchdog with delve support. It enables the tests
## to be debugged inside a container.
##
## Run with:
## docker run --memory=64MiB --memory-swap=64MiB -p 2345:2345 <image> \
##     --listen=:2345 --headless=true --log=true \
##     --log-output=debugger,debuglineerr,gdbwire,lldbout,rpc \
##     --accept-multiclient --api-version=2 exec /root/watchdog.test
##