# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn install -N -DskipTests

COPY common-library/pom.xml common-library/pom.xml
COPY common-library/src common-library/src
RUN mvn -f common-library/pom.xml install -DskipTests

# DEBUG: check what's inside the JAR BEFORE building order-service
RUN echo "=== JAR CONTENTS ===" && \
    jar tf ~/.m2/repository/com/hacisimsek/common-library/0.0.1-SNAPSHOT/*.jar | grep -E "\.class$" | head -30

COPY order-service/pom.xml order-service/pom.xml
COPY order-service/src order-service/src
RUN mvn -f order-service/pom.xml clean package -DskipTests