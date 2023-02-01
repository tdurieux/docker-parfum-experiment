# This is the base slow-changing Dockerfile for the core of UmpleOnline
# The following should be updated from values at https://hub.docker.com/_/nginx
# Updated from 1.19-alpine in Spring 2022

FROM --platform=linux/amd64 nginx:1.21-alpine

MAINTAINER Umple umple-help@googlegroups.com

# give php its own user and install UmpleOnline's dependencies