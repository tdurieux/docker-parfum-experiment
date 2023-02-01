# Copyright 2020 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# This is not a builder image. Rather, it's a Debian image with common
# debugging tools, useful when debugging things on Container Optimized
# OS VMs without external network access that can at least run docker
# images from gcr.io.