# Top level ARGS used in all FROM commands
ARG SHIM
ARG DEPS

FROM ${DEPS}${SHIM} as jvm-staging

# Arguments used in build-jvm.sh