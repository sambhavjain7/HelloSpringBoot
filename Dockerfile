# Use a base image with Java and Maven installed
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src

#Instructs the maven to clean project, resolve dependecies, compile sosurce code, skip tests and package into jar file.
# Maven will automicatlly downloads dependecies specified in pom.xml and caches them in maven repository (~/.m2)
RUN mvn clean package -DskipTests -X

# Use a lightweight base image for the application runtime
FROM openjdk:11-jre-slim
WORKDIR /app

# Copy the built JAR file from the previous stage
# - The JAR file created by Maven is named `code.jar`.
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar HelloWorldApplication.jar

#Expose HTTPS port for Container to listen on
EXPOSE 8080

# Specify the command to run your application
CMD ["java", "-jar", "HelloWorldApplication.jar"]


