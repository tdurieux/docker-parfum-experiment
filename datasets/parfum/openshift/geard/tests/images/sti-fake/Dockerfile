FROM busybox
RUN mkdir -p /sti-fake/src

# FIXME: The 'default' user has conflicting UID (1000). This should be fixed in
#        how geard handle UID's during isolation.
#
RUN deluser default
WORKDIR /

# Need to serve the scripts from localhost so any potential changes to the
# scripts are made available for integration testing.
#
# Port 23456 must match the port used in the http server in STI's
# integration_test.go
ENV STI_SCRIPTS_URL http://localhost:23456/sti-fake/.sti/bin
