#
#

quit -sim

vsim -f ./sim.f work.tb_top

# log all signals
log /* -r
