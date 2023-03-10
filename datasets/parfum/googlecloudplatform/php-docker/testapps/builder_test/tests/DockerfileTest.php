<?php
/**
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
namespace Google\Cloud\tests;

use PHPUnit\Framework\TestCase;

class DockerfileTest extends TestCase
{
    public function testDockerfile()
    {
        $dockerfile = file_get_contents('/workspace/Dockerfile');
        $this->assertNotFalse(is_string($dockerfile));
        $this->assertNotFalse(str_contains($dockerfile, "DOCUMENT_ROOT='/app/web'"));
    }
}
