# Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may
# not use this file except in compliance with the License. A copy of the
# License is located at
#
#	http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
FROM public.ecr.aws/docker/library/gcc:11.2.0 as build

WORKDIR /src/
ADD . /src/

RUN gcc -Os -Wall -Werror -static ./pause.c -o pause

FROM scratch
COPY --from=build /src/pause /
ENTRYPOINT ["/pause"]
