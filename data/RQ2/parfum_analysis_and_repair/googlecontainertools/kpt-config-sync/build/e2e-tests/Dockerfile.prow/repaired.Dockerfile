# Dockerfile for the prow test environment

# We'd use the kubekins-e2e straight away, but it's missing the 'kind' binary.

# Ensure versions in this file match those in Makefile.prow. This is not
# neccessarily a strict requirement since the versions passed in the Makefile
# will override any defaults set here, however having the same versions set
# between these two files will eliminate any confusion on what versions are
# actually being used.