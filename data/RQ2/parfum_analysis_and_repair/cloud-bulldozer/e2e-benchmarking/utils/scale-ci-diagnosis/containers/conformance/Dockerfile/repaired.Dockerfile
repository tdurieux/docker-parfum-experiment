# Dockerfile for conformance

FROM quay.io/openshift/origin-tests:latest as origintests

FROM centos:7

MAINTAINER Red Hat OpenShift Performance and Scale

ENV KUBECONFIG /root/.kube/config

# Copy OpenShift CLI, Kubernetes CLI and openshift-tests binaries from origin-tests image