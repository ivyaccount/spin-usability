/* Reference from producer consumer */

mtype = { INIT, GET_IMAGE, STOP_IMAGE, RESET, READ_IMAGE_CMD, WRITE_IMAGE_CMD, GET_SENSOR_DATA}; /* symbols used */
mtype command = INIT; /* shared */
bool task_control_flag;

/* for task process image */
chan ping_pong_buffer = [2] of { byte }; /* channel having 2 byte of capacity */


proctype Task_process_command(){
  generate_random_command();
  
  do
  :: (command == INIT) -> /* Guard */
    printf("Init\n");
    //turn = C
  :: (command == GET_IMAGE) -> 
    printf("Get image\n");

  :: (command == STOP_IMAGE) -> 
    printf("Stop getting image\n");

  :: (command == RESET) -> 
    printf("Reset\n");

  :: (command == READ_IMAGE_CMD) -> 
    printf("Read image command\n");

  :: (command == WRITE_IMAGE_CMD) -> 
    printf("Write image command\n");

  :: (command == GET_SENSOR_DATA) -> 
    printf("Get sensor data\n");

  :: else -> 
    printf("Unknown command")
  od
}

proctype Task_process_image(){
  do
  :: (task_control_flag == 1)
    //fail counts > max, reset with RESET
    
    //wait semaphore
    
    //get segment (for small cam)
    
    //wait semaphore
    
    //transfer
      //semaphore for producer
  od
}

proctype generate_random_command(){
  if
  :: skip -> command=INIT
  :: skip -> command=GET_IMAGE
  :: skip -> command=STOP_IMAGE
  :: skip -> command=RESET
  :: skip -> command=READ_IMAGE_CMD
  :: skip -> command=WRITE_IMAGE_CMD
  :: skip -> command=GET_SENSOR_DATA
  fi
}

init {
  atomic {
    int pid_process_cmd = run Task_process_command();
    //before this task, we are creating 2 semaphores
    int pid_process_image = run Task_process_image();
  }
}
/* Reference */
active proctype producer(){
  do
  :: (turn == P) -> /* Guard */
    printf("Produce\n");
    turn = C
  od
}


active proctype consumer(){
again:
  if
  :: (turn == C) -> /* Guard */
    printf("Consume\n");
    turn = P;
    goto again
  fi
}
