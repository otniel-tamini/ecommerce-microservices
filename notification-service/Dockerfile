# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# 1. Install the parent POM only (-N = non-recursive, ignores child modules)
COPY pom.xml .
RUN mvn install -N -DskipTests

# 2. Build & install common-library into local .m2
COPY common-library/pom.xml common-library/pom.xml
COPY common-library/src common-library/src
RUN mvn -f common-library/pom.xml install -DskipTests

# 3. Now resolve notification-service dependencies (parent is already in local .m2)
COPY notification-service/pom.xml notification-service/pom.xml
RUN mvn -f notification-service/pom.xml dependency:go-offline

# 4. Copy source and build
COPY notification-service/src notification-service/src
RUN mvn -f notification-service/pom.xml clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=build /app/notification-service/target/*.jar app.jar
EXPOSE 8084
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]