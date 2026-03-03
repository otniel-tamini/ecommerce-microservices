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

# 3. Now resolve shipping-service dependencies (parent is already in local .m2)
COPY shipping-service/pom.xml shipping-service/pom.xml
RUN mvn -f shipping-service/pom.xml dependency:go-offline

# 4. Copy source and build
COPY shipping-service/src shipping-service/src
RUN mvn -f shipping-service/pom.xml clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=build /app/shipping-service/target/*.jar app.jar
EXPOSE 8085
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]