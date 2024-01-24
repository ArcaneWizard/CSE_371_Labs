onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FIFO_Control_testbench/clk
add wave -noupdate /FIFO_Control_testbench/reset
add wave -noupdate /FIFO_Control_testbench/read
add wave -noupdate /FIFO_Control_testbench/write
add wave -noupdate /FIFO_Control_testbench/frontValue
add wave -noupdate /FIFO_Control_testbench/readValue
add wave -noupdate /FIFO_Control_testbench/wr_en
add wave -noupdate /FIFO_Control_testbench/empty
add wave -noupdate /FIFO_Control_testbench/full
add wave -noupdate /FIFO_Control_testbench/readAddr
add wave -noupdate /FIFO_Control_testbench/writeAddr
add wave -noupdate /FIFO_Control_testbench/dut/fifo_count
add wave -noupdate /FIFO_Control_testbench/dut/fullCount
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {68 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 334
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {163 ps}
