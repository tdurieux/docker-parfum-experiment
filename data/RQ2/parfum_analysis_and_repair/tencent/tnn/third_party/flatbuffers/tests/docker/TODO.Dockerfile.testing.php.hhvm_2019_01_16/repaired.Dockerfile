# This does not pass tests due to the following error:
#
# Fatal error: Uncaught exception 'InvalidArgumentException' with message 'Google\FlatBuffers\ByteBuffer::getX() expects parameter 1 by reference, but the call was not annotated with '&'. in /code/php/FlatbufferBuilder.php:971
# Stack trace:
# #0 /code/tests/phpTest.php(277): Google\FlatBuffers\FlatbufferBuilder->sizedByteArray()
# #1 /code/tests/phpTest.php(79): fuzzTest1()
# #2 /code/tests/phpTest.php(86): main()
# #3 {main}
#   thrown in in /code/php/FlatbufferBuilder.php:971