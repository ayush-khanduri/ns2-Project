BEGIN {
     recvdSize = 0 
 	}

 	{
 	     # Trace line format: normal
 
 	     if ($2 != "-t") {
 
 	           event = $1
 
 	           time = $2
 
 	           if (event == "+" || event == "-") node_id = $3
 
 	           if (event == "r" || event == "d") node_id = $4
 
 	           flow_id = $8
 
 	           pkt_id = $12
 
 	           pkt_size = $6
 
 	           flow_t = $5
 
 	           level = "AGT"
 
 	     } 
 	     # Trace line format: new

 	     if ($2 == "-t") {
 
 	           event = $1
 
	           time = $3
 
 	           node_id = $5
 
 	           flow_id = $39
 
 	           pkt_id = $41
 
 	           pkt_size = $37
 
 	           flow_t = $45
 
 	           level = $19
 	     }

 	# Store start time
 	if (level == "AGT" && (event == "+" || event == "s") && pkt_size>= 512) {
 	  if (time < startTime) {
 
 	           startTime = time
 
 	           }
 
 	     }
 
 	# Update total received packets' size and store packets arrival time
 
 	if (level == "AGT" && event == "r" && pkt_size >= 512) {
 
 	     if (time > stopTime) {
 
 	           stopTime = time
 
            }
 	     # Rip off the header
 
	     hdr_size = pkt_size % 512
 
 	     pkt_size -= hdr_size
 
 	     # Store received packet's size
 
 	     recvdSize += pkt_size
 
 	     }
 
 	}
 
 	END {
 	     printf("Average Throughput[kbps] = %.2f\t\tStartTime=%.2f\tStopTime=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime)
 	}
