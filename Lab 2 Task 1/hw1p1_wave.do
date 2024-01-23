onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hw1p1_testbench/clk
add wave -noupdate /hw1p1_testbench/reset
add wave -noupdate /hw1p1_testbench/x
add wave -noupdate /hw1p1_testbench/y
add wave -noupdate /hw1p1_testbench/sum
add wave -noupdate /hw1p1_testbench/carry_out
add wave -noupdate /hw1p1_testbench/dut/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {69 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 222
configure wave -valuecolwidth 156
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1885 ps}
