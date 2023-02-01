# SPDX-FileCopyrightText: 2020 TQ Tezos <https://tqtezos.com/>
#
# SPDX-License-Identifier: LicenseRef-MIT-TQ
FROM alpine:3.12 as binary-fetch
# Latest v5.0.0-2 qemu-user-static has some weird bug that causes curl and wget to segfault.
# See https://bugs.launchpad.net/qemu/+bug/1892684.