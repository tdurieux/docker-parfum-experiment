# Copyright 2019 The Kubernetes Authors.
# SPDX-License-Identifier: Apache-2.0

# TODO(jlewi): We end up pulling go.mod for all of kfctl which pulls in a lot of dependencies
# which slows down builds. That's pretty unnecessary. The only code shared with kfctl is
# some test utilities in particular utils.PrintDiff it might be worthmaking the test package
# its own go module so we don't have to pull in so many dependencies just to build
# our kustomize functions.