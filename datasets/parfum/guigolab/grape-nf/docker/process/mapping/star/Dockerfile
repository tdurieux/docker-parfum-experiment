# Dockerfile for the grape-nf STAR mapping step
#
ARG STAR_VER=2.4.0j
ARG SAMBAMBA_VER=0.7.1

FROM grapenf/star:${STAR_VER} as star
FROM grapenf/sambamba:${SAMBAMBA_VER} as sambamba

FROM grapenf/base

LABEL author.name="Emilio Palumbo"
LABEL author.email="emiliopalumbo@gmail.com"

COPY --from=star /usr/local/bin/STAR /usr/local/bin/
COPY --from=sambamba /usr/local/bin/sambamba /usr/local/bin/
