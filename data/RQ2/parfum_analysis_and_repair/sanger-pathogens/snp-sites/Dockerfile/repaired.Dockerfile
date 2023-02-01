#
#  From this base-image / starting-point
#
FROM debian:testing

#
#  Authorship
#
MAINTAINER path-help@sanger.ac.uk

#
# Pull in packages from testing
#
RUN apt-get update -qq && apt-get -y --no-install-recommends install snp-sites && rm -rf /var/lib/apt/lists/*; #
# Install SNP-sites
#

