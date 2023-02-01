FROM nginx:latest
# needed to investigate PID of running process
RUN apt -y update ; apt -y --no-install-recommends install procps && rm -rf /var/lib/apt/lists/*;
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
CMD [ "/entrypoint.sh" ]
