#
#  Author: Hari Sekhon
#  Date: 2021-12-06 16:44:16 +0000 (Mon, 06 Dec 2021)
#
#  vim:ts=4:sts=4:sw=4:et
#
#  https://github.com/HariSekhon/Dockerfiles
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# running kustomize command breaks horribly on 'kustomize edit', even 'kustomize version' hangs - even with gcompat - probaby due to musl vs libc
#FROM alpine/git:v2.32.0
#FROM ubuntu:20.04
# a little smaller image
# nosemgrep: dockerfile.audit.dockerfile-source-not-pinned.dockerfile-source-not-pinned