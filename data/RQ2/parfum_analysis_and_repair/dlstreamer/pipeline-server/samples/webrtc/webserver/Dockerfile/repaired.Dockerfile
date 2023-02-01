#!/bin/bash
#
# Copyright (C) 2022 Intel Corporation.
#
# SPDX-License-Identifier: BSD-3-Clause
#
ARG BASE=nginx:latest

FROM $BASE

# Extends Centricular example found here:
# https://gitlab.freedesktop.org/gstreamer/gst-examples/-/tree/master/webrtc/sendrecv/js