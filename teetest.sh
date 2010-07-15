#!/bin/bash
PIPEFILE=/tmp/teepipe.pipe
LOGFILE=/root/StackScript.log

mkfifo $PIPEFILE

# Start tee writing to a logfile, but pulling its input from our named pipe.
tee $LOGFILE < $PIPEFILE &

# capture tee's process ID for the wait command.
TEEPID=$!

# henceforth, redirect the rest of the stderr and stdout to our named pipe.
exec > $PIPEFILE 2>&1

#WORK

# close the stderr and stdout file descriptors.
exec 1>&- 2>&-

# Wait for tee to finish since now that other end of the pipe has closed.
wait $TEEPID


echo 'all complete'
