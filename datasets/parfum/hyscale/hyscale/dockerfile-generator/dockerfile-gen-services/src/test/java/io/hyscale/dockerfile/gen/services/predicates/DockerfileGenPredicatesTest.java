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
package io.hyscale.dockerfile.gen.services.predicates;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;

import java.util.function.Predicate;
import java.util.stream.Stream;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import io.hyscale.commons.exception.HyscaleException;
import io.hyscale.dockerfile.gen.services.util.ServiceSpecTestUtil;
import io.hyscale.servicespec.commons.model.service.ServiceSpec;

class DockerfileGenPredicatesTest {

    private static Stream<Arguments> input() {
        return Stream.of(Arguments.of(DockerfileGenPredicates.skipDockerfileGen(), null, false),
                Arguments.of(DockerfileGenPredicates.skipDockerfileGen(), "/input/skip-generation/dockerfile.hspec", true),
                Arguments.of(DockerfileGenPredicates.skipDockerfileGen(), "/input/skip-generation/stack-as-service.hspec", true),
                Arguments.of(DockerfileGenPredicates.skipDockerfileGen(), "/input/skip-generation/only-image.hspec", true),
                Arguments.of(DockerfileGenPredicates.skipDockerfileGen(), "/input/skip-generation/invalid-spec.hspec", true),
                Arguments.of(DockerfileGenPredicates.skipDockerfileGen(), "/input/skip-generation/dont-skip.hspec", false));
    }
    
    @ParameterizedTest
    @MethodSource("input")
    void testPredicate(Predicate<ServiceSpec> predicate, String serviceSpecPath, boolean result) {
        try {
            ServiceSpec serviceSpec = ServiceSpecTestUtil.getServiceSpec(serviceSpecPath);
            assertEquals(predicate.test(serviceSpec), result);
        } catch (HyscaleException e) {
            fail(e);
        }
    }
}
