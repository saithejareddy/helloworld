FROM openjdk

COPY Hello.java /
RUN javac Hello.java
CMD sleep 10000
