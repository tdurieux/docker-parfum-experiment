FROM lkastner/m2_interactive_shell:latest
MAINTAINER InteractiveShell Team <trym2@googlegroups.com>

COPY docker_key.pub /home/m2user/.ssh/authorized_keys
RUN chmod 644 /home/m2user/.ssh/authorized_keys

