onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Frame_Buffer_opt

do {wave.do}

view wave
view structure
view signals

do {Frame_Buffer.udo}

run -all

quit -force
