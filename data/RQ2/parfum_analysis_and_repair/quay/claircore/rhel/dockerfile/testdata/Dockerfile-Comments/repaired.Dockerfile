# Normal comments are fine
FROM scratch

LABEL \
	# This style of comment is buck wild, but allowed.
	A=B \
	C=D
	# This comment is stripped despite the apparent continuation