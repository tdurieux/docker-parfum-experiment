# syntax=docker/dockerfile:1.3-labs

FROM ubuntu:21.04

RUN <<EOF
ps faux
EOF