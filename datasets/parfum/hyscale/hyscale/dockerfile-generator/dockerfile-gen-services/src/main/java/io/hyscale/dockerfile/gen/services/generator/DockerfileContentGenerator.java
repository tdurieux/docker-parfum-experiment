/**
 * Copyright 2019 Pramati Prism, Inc.
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
package io.hyscale.dockerfile.gen.services.generator;

import io.hyscale.commons.exception.HyscaleException;
import io.hyscale.dockerfile.gen.core.models.DockerfileContent;
import io.hyscale.dockerfile.gen.services.model.DockerfileGenContext;
import io.hyscale.servicespec.commons.model.service.ServiceSpec;

public interface DockerfileContentGenerator {

	public DockerfileContent generate(ServiceSpec serviceSpec, DockerfileGenContext context) throws HyscaleException;
}
