# Can use abritary base images but likely want to standardize across an event
# to best take advantage of caching.
FROM gcc:10

RUN apt-get update && apt-get install -y \
    socat

WORKDIR /challenge

# Copy in source file
COPY vuln.c /challenge/vuln.c

# Compile with mitigations disabled
RUN gcc vuln.c -o vuln -fno-stack-protector -z execstack -no-pie

# FLAG is passed in as a BUILD_ARG in `initialize_docker`
# this is an alternative to using picoCTF templating
ARG FLAG
RUN echo ${FLAG} > /challenge/flag

EXPOSE 5555
CMD ["socat", "TCP-LISTEN:5555,reuseaddr,fork", "EXEC:/challenge/vuln"]
