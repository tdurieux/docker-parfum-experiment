# Copyright 2020 DSR Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

################################################################################
# Builds dcld application for further use on nodes in DCL pool in docker.
# The resulting image is used only for getting the build artifact from
# a container based on it. Containers based on this image are never run.
################################################################################
FROM golang:alpine

# git is required for fetching the dependencies,
# make is required for building,
# build-base is needed because gcc is required for building.