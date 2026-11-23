# Estágio 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
# Copia o pom.xml e baixa as dependências (cache do Docker)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código fonte e gera o pacote .jar
COPY src ./src
RUN mvn clean package -DskipTests

# Estágio 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
# Copia apenas o jar gerado no estágio anterior
COPY --from=build /app/target/*.jar app.jar

# Porta que o Spring Boot usa por padrão
EXPOSE 8080

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
