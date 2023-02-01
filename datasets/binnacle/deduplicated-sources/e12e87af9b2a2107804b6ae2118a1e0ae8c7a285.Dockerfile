FROM debian:latest

MAINTAINER Brent Salisbury <brent.salisbury@gmail.com>

RUN apt-get update -q \
    && apt-get install -y netcat-openbsd \
    && apt-get clean

# Test usage running the script manually:
#  generate_test_grafana_data.sh
#  [ DB_IP (required)]
#  [ DB_PORT (optiona)]
#  [ NUMBER_COUNT (optiona)]
#  [ LOOP_INTERVAL (optiona)]"
# Example: generate_test_data.sh 192.168.99.100 2003 10 15
# Or use docker-machine ip <MACHINE_NAME> to get
# the target machine IP addr dynamicly
# Example:
# scripts/generate_test_grafana_data.sh \
#     $(docker-machine ip virtualbox-machine) 2003 100 15

# The total runtime is 30 minutes,
# 4 ticks per/min ($LOOP_INTERVAL)
# Number of data points the test sends
ENV ENTRY_COUNT 120
# Default time between data entries
ENV LOOP_INTERVAL 15

# Directory to copy and run the test script from
WORKDIR /usr/local/src
COPY generate_test_data.sh ./generate_test_data.sh
RUN chmod +x ./generate_test_data.sh
ENTRYPOINT ["./generate_test_data.sh"]

