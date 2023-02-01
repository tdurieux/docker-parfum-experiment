# Copyright (c) 2020 Gitpod GmbH. All rights reserved.
# Licensed under the GNU Affero General Public License (AGPL).
# See License-AGPL.txt in the project root for license information.

FROM scratch

# BEWARE: This must be the first layer in the image, s.t. that blobserve
#         can serve the IDE host. Even moving WORKDIR before this line
#         would break things.