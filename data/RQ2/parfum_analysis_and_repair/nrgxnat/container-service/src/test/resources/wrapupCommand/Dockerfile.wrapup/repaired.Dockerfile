FROM busybox:latest
COPY wrapup-command-script.sh /usr/local/bin/
LABEL org.nrg.commands="[{\"inputs\": [], \"name\": \"wrapup-command\", \"command-line\": \"wrapup-command-script.sh\", \"xnat\": [], \"image\": \"xnat/test-wrapup-command:latest\", \"mounts\": [], \"type\": \"docker-wrapup\", \"description\": \"A wrapup command\"}]"