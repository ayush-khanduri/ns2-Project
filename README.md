# ns2-Project
The project contains two tcl files aodv.tcl and dsdv.tcl and two awk files throughput.tcl and packets_dropped.awk to be run on their trace files to compare the throughput and packets dropped in both AODV and DSDV routing protocols.


-> To install ns and nam on ubuntu refer http://askubuntu.com/a/510643.

-> For Windows users may god help you.

To execute :-

1. Open the terminal and run the tcl scripts using <strong>ns filename.tcl</strong> to generate the nam and trace file.

2. To execute the awk files use awk -f (awk filename) (trace filename)

   Ex : awk -f throughput.awk aodv.tr
