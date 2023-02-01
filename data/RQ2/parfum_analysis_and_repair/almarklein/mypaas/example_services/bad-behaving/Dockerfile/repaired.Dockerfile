# Example Dockerfile for a bad behaving process. By applying appropriate
# limits, the behavior does not affect the server much.
#
# After testing this, you can stop the service using: docker rm -f bad-behaving
#
# mypaas.service = bad-behaving
# mypaas.maxcpu = 0.05
# mypaas.maxmem = 50m