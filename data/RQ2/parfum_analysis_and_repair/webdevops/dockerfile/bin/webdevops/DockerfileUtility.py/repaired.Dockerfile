#!/usr/bin/env/python
# -*- coding: utf-8 -*-
#
# (c) 2016 WebDevOps.io
#
# This file is part of Dockerfile Repository.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions
# of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import os
import re

DOCKERFILE_STATEMENT_FROM_RE = re.compile(ur'FROM\s+(?P<image>[^\s:]+)(:(?P<tag>[^\s:]+))?(?!.*\s+AS)', re.MULTILINE)
DOCKERFILE_STATEMENT_FROM_MULTISTAGE_RE = re.compile(ur'FROM\s+(?P<image>[^\s:]+)(:(?P<tag>[^\s:]+))?(\s+AS)', re.MULTILINE)

def find_file_in_path(dockerfile_path, filename="Dockerfile", whitelist=False, blacklist=False):
    """
    Search all file un dockerfile_path with filename ends with "filename"
    And match filter

    :param dockerfile_path: path where to search file
    :type dockerfile_path: str

    :param filename: pattern which the file must be validate
    :type filename: str

    :param whitelist: list of term must be match in path
    :type whitelist: list

    :param blacklist: list of term must not be match in path
    :type blacklist: list

    :return: list of path
    :rtype: list
    """
    file_list = []

    # build list of files
    for root, dirs, files in os.walk(dockerfile_path):
        for file in files:
            if file.endswith(filename):
                file_list.append(os.path.join(root, file))

    # filter by whitelist
    if whitelist:
        tmp = []
        for file in file_list:
            for term in whitelist:
                if term in file:
                    tmp.append(file)
                    break
        file_list = tmp

    if blacklist:
        for term in blacklist:
            file_list = filter(lambda x: term not in x, file_list)

    return file_list

def find_dockerfiles_in_path(base_path, path_regex, image_prefix, whitelist=False, blacklist=False):
    """
    Find all Dockerfiles in path (and even in symlinks and build dependencies)
    """

    def parse_docker_info_from_path(path):
        image_name_info = ([m.groupdict() for m in path_regex.finditer(os.path.abspath(path))])[0]

        image_repository = (image_name_info['repository'] if 'repository' in image_name_info else '')
        image_name = (image_name_info['image'] if 'image' in image_name_info else '')
        image_tag = (image_name_info['tag'] if 'tag' in image_name_info else '')

        image_is_duplicate = False

        # check if path is linked