# This builds the source distributions for all components

# Builds the wforce sdist in a separate stage
@IF [ ! -z "$M_all$M_wforce" ]
@INCLUDE Dockerfile.wforce
@ENDIF

FROM alpine:3.6 as sdist

# Copy wforce tarball
@IF [ ! -z "$M_all$M_wforce" ]
COPY --from=wforce /sdist/ /sdist/
@ENDIF

# Show contents for build debugging