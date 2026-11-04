# 1단계: WAR 빌드 (테스트는 CI 에서 돌리므로 여기선 생략)
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY pom.xml .
RUN mvn -B -ntp dependency:go-offline
COPY src ./src
RUN mvn -B -ntp package -DskipTests

# 2단계: 톰캣 11 에 web.war 로 배포 → http://localhost:8080/web
FROM tomcat:11.0-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /src/target/web.war /usr/local/tomcat/webapps/web.war
ENV TZ=Asia/Seoul \
    MYAUCT_CONFIG=/config/app.properties \
    CATALINA_OPTS="-Duser.timezone=Asia/Seoul"
EXPOSE 8080
