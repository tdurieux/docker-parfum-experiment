# syntax=docker/dockerfile:1.3-labs

FROM ubuntu:21.04

RUN <<EOF
#!/bin/bash
ps faux
EOF