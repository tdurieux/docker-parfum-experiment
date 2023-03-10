# первая ступень - базовый образ - OpenJDK 11 и установленный Maven
FROM maven:3.6.2-jdk-11 as builder

# Соберем и запустим приложение в этой директории
WORKDIR /app

# Для сборки проекта Maven нужны исходные тексты программы
# и непосредственно файл сборки pom.xml
COPY pom.xml ./
COPY src/ ./src/

# Компиляция, сборка и упаковка приложения в архив JAR
RUN mvn package

# Минимальная версия JRE, версия 11, открытая версия OpenJDK
FROM openjdk:11-jre-slim

# Используем такую же рабочую директорию
WORKDIR /app
# Скопируем архив JAR из первой ступени
COPY --from=builder /app/target/hello-world-1.0.0.jar .

# Запуск приложения виртуальной машиной Java OpenJDK 11