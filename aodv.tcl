#akchamp
#------------------------------------------------#
#----------	Define Physical layer	-------------#
#------------------------------------------------#

set val(ch)           Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type

#------------------------------------------------#
#--------	Scenario based conditons	---------#
#------------------------------------------------#
set val(x)            1000 
set val(y)            1000  
set val(nn)           5
set val(r_pro)        AODV                     ;# ad-hoc routing protocol 
set val(ifqlen)       10                       ;# max packet in ifq(queue)
set val(stop)         200                      ;# simulation ends
# So it begins...
set ns [new Simulator]

set tracefd [open aodv.tr w]

set namtrace [open aodv.nam w]
$ns trace-all $tracefd

$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)
# namastey kro _/\_

$ns node-config -adhocRouting $val(r_pro) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(ch) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace ON

for {set i 0} {$i < $val(nn) } {incr i} {
set node($i) [$ns node]
$node($i) random-motion 0       ;# disable random motion
}

#node initial locations
$node(0) set X_ 100.0
$node(0) set Y_ 200.0
$node(0) set Z_ 0.0

$node(1) set X_ 200.0
$node(1) set Y_ 300.0
$node(1) set Z_ 0.0

$node(2) set X_ 300.0
$node(2) set Y_ 400.0
$node(2) set Z_ 0.0

$node(3) set X_ 400.0
$node(3) set Y_ 500.0
$node(3) set Z_ 0.0

$node(4) set X_ 500.0
$node(4) set Y_ 600.0
$node(4) set Z_ 0.0

#new locations 
$ns at 0.0 "$node(0) setdest 150.0 300.0 5.0"
$ns at 0.0 "$node(1) setdest 250.0 700.0 31.0"
$ns at 1.0 "$node(2) setdest 15.0 330.0 23.0"
$ns at 1.0 "$node(3) setdest 450.0 300.0 12.0"
$ns at 3.0 "$node(4) setdest 180.0 365.0 15.0"

#Setup a TCP connection
set src [new Agent/TCP]
$src set class_ 2
$ns attach-agent $node(0) $src
set sink [new Agent/TCPSink]
$ns attach-agent $node(4) $sink
$ns connect $src $sink
$src set fid_ 1

#Setup a FTP connection
set ftp [new Application/FTP]
$ftp attach-agent $src
$ftp set type_ FTP

# Define nodes initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
$ns initial_node_pos $node($i) 25
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "$node($i) reset";
}


$ns at 0 "$ftp start"
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at 200.5 "puts \"aodv finish\" ; $ns halt"

proc finish {} {
global ns tracefd namtrace
$ns flush-trace
close $tracefd
close $namtrace
exec nam aodv.nam &
exit 0
}
$ns run






  
