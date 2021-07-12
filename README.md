1)Run the container image infracloudio/csvserver:latest in background and check if it's running.
ans:  container not running into background


2)If it's failing then try to find the reason, once you find the reason, move to the next step.
 ANS:because /csvserver/inputdata this file not present images so i have created that file and attached that folder as volume container then 
 it satrted. now container is running.
 
 command:docker run -d -v /csvserver/inputdata:/csvserver/inputdata  infracloudio/csvserver:latest
 
 3)Write a bash script gencsv.sh to generate a file named inputFile whose content looks like
 
 ANS:nano gencsv.sh
 
 #!/bin/bash
RANDOM=$$
DEFAULT_VALUE=10
random_no_range="${1:-$DEFAULT_VALUE}"
for i in `seq $random_no_range`
do
 echo $((i-1)), $RANDOM
done > inputFile
chmod o+r inputFile

 
 4)docker cp inputFile  c4736564f58c:/csvserver/inputFile
 

5)get shell and check on which port server is running
  get the shell
     docker exec -it c4736564f58c  /bin/bash
  check the port number on which service is running.
       netstat -tunlp
  found that application running on the 9300 port number.
  
  After that stopped that container
  docker stop c4736564f58c
  
 6)
   a)docker run -d -v /csvserver/inputdata:/csvserver/inputdata -p 9393:9300  infracloudio/csvserver:latest  

   b)docker run -d -v /csvserver/inputFile:/csvserver/inputdata -p 9393:9300 -e "CSVSERVER_BORDER=Orange"   infracloudio/csvserver:latest
 
 
 
 PART 2  docker-compose.yaml
     
version: "3.3"
services:
        csvserver:
          image: infracloudio/csvserver:latest
          volumes:
            - /csvserver/inputFile:/csvserver/inputdata
          ports:
            - "9393:9300"
          environment:
            - CSVSERVER_BORDER=Orange  
            
      
part3

For exposing csvserver metrics on prometheus without using docker-compose

docker run --name csvserver -p 9393:9300 --network db_network --env CSVSERVER_BORDER=Orange -v "/csvserver/inputFile:/csvserver/inputdata:z -d infracloudio/csvserver:latest

docker run --name prometheus-server --publish 9090:9090 --mount type=bind,src=/csvserver/prometheus.yml,target=/etc/prometheus/prometheus.yml --network db_network -d prom/prometheus:v2.22.0

(Note : You need to have files inputFile & prometheus.yaml in your current directory.You can get these files from solution folder)

Using docker-compose exposing csvserver metrics on prometheus

docker-compose up -d

(Note : You need to have files inputFile,prometheus.yaml & docker-compose.yaml in your current directory.You can get these files from solution folder)

