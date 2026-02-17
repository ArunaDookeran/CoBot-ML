
Instructions to start the pytorch docker container for YOLO models

1. open up the terminal
   
3. run './run_yolo.sh'
   
  2.1. if that fails you may need to run some additional commands
  
  2.2. run 'sudo usermod -aG docker $USER'
  
  2.3. run 'newgrp docker'
  
  2.4. retry './run_yolo.sh'
  
4. now you should be in the container, follow the remaining to run the demo
   
6. run 'cd YOLOv8-Face/'
   
8. run 'python demoYolo.py'


The workspace outside of the container is located at:
   ~/ML_AI/docker-workspace/
   
The Dockerfile is located at:
   ~/ML_AI/Docker/
   
To rebuild the Docker container:
1. navigate terminal to directory with Dockerfile
2. run 'docker build --network=host -t <container-name>:latest .'


Note: the 'run_yolo.sh' script uses the 'yolo-jetson' container name

Don't forget to restart the container afterwards
