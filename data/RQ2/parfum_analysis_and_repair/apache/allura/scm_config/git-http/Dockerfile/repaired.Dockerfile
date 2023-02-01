#       Licensed to the Apache Software Foundation (ASF) under one
#       or more contributor license agreements.  See the NOTICE file
#       distributed with this work for additional information
#       regarding copyright ownership.  The ASF licenses this file
#       to you under the Apache License, Version 2.0 (the
#       "License"); you may not use this file except in compliance
#       with the License.  You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#       Unless required by applicable law or agreed to in writing,
#       software distributed under the License is distributed on an
#       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#       KIND, either express or implied.  See the License for the
#       specific language governing permissions and limitations
#       under the License.


# loosely inspired by https://github.com/jacksoncage/apache-docker/blob/ubuntu/Dockerfile
# not inspired by https://hub.docker.com/_/httpd/ which does a custom source-based install of httpd

# match main allura Dockerfile, for shared base
FROM ubuntu:18.04

# libapache2-mod-python is for py2 (both ubuntu:18.04 and ubuntu:20.04)
# to match that, python-requests is also py2 on ubuntu:18.04 (probably python2-requests on ubuntu:20.04)
# https://forge-allura.apache.org/p/allura/tickets/8352/ is to switch to mod_wsgi & py3 instead