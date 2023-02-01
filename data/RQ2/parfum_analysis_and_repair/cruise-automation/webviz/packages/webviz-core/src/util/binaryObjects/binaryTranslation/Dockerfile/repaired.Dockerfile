#  Copyright (c) 2018-present, Cruise LLC
#
#  This source code is licensed under the Apache License, Version 2.0,
#  found in the LICENSE file in the root directory of this source tree.
#  You may not use this file except in compliance with the License.

FROM trzeci/emscripten:1.39.17-upstream

RUN apt-get update && apt-get -y --no-install-recommends install clang-format clang-tidy && rm -rf /var/lib/apt/lists/*;

