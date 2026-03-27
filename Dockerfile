# Stage 1: Build Image
# เปลี่ยนจาก openjdk:11 เป็น eclipse-temurin:11
FROM eclipse-temurin:11-jdk-jammy AS BUILD_IMAGE
RUN apt update && apt install maven -y
COPY ./ vprofile-project
RUN cd vprofile-project && mvn install 

# Stage 2: Runtime Image
# เปลี่ยนจาก tomcat:9-jre11 เป็นเวอร์ชันที่ระบุ OS ชัดเจนเพื่อให้ดึงได้ชัวร์
FROM tomcat:9.0-jre11-temurin-jammy
LABEL "Project"="Vprofile"
LABEL "Author"="Sornsub"

RUN rm -rf /usr/local/tomcat/webapps/*

# Copy ไฟล์ .war จาก Stage แรก
COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
