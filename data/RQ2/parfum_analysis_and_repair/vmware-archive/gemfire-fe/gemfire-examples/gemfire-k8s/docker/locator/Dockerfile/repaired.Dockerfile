FROM gemfire-base:9.3.0

COPY generate_script.sh /opt/gemfire/bin
EXPOSE 10334 1099 7070