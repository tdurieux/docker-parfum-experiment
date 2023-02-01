# Uses a multi-stage container build to build the RP in OneBranch.
#
# TODO:
# OneBranch pipelines currently pull from CDPx which is deprecated. As a temporary fix before
# we migrate to a new solution, this multistage dockerfile uses the same image in both steps to avoid
# needing to pull images that aren't hosted in CDPx.