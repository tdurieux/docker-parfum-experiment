# This dockerfile is meant to use on externally built binary using command:
# GOOS=linux GOARCH=amd64 go build -o ./needs-tws .
# then use docker build -t needs-tws .
# NOT MEANT FOR AUTOBUILDS