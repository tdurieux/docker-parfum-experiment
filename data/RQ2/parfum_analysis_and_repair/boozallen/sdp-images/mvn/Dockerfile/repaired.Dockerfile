# Copyright © 2022 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. 
# The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.6-754

# importing Maven from public image (version available from UBI base package repos is for JDK8)