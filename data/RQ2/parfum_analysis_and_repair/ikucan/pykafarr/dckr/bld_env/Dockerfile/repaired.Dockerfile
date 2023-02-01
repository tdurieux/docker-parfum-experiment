# -------------------------------------------------------
# NOTE: when run, this container starts an ssh deamon,
#       use with caution
# -------------------------------------------------------

FROM ikucan/pykafarr_dev:1.0.0

# use bash instead of sh
SHELL ["/bin/bash", "-c"]

#
## add conda build package(s)
#