# Copyright 2019 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.13.4-alpine3.10 as builder
ENV GO111MODULE=on

# ###################################
# ###################################
# ###################################
# So here's the deal: There's a "bug" in go 1.13 (see 
# https://github.com/golang/go/issues/35111) where they hadn't actually
# implemented freeing objects in javascript that were no longer referenced in
# Go. So having new references to the objects required to call webgl rapidly
# caused memory leaks. It's fixed in go's master, but won't be in the proper
# release until go 1.14.  The fix is to build go from source (commit chosen to
# be the latest as of writing) and then use that to build only the client. 
# Unfortunate "workaround", but there was some good luck, the fix was only
# added the Monday of the week before writing this.