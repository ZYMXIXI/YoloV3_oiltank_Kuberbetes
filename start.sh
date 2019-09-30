#!/bin/bash
cd /YOLO/yolov3_oiltank/
#nohup python yolo_test.py >>./watch.out &
python yolo_test.py

sleeptime=1000
while((1));do
  now=`date '+%Y-%m-%d %H:%M:%S'`   
  echo $now>>./watch.out 
  sleep $sleeptime
done

