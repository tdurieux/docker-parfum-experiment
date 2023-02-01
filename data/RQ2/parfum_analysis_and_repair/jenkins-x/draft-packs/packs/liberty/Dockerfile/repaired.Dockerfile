#use open liberty runtime
FROM openliberty/open-liberty:javaee7
ENV PORT 9080
EXPOSE 9080
# Symlink servers directory for easier mounts.