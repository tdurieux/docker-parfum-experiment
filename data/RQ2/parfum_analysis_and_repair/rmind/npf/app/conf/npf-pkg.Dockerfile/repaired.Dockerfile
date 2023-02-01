##########################################################################
# NPF builder -- contains all the dependencies
#
FROM npf-deps AS npf-pkg

#
# - Copy over the source code and build NPF.
# - Build the standalone NPF components.
# - Copy over the NPF packages.
#