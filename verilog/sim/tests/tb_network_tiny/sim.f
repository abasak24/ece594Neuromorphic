#
#

# # +UVM_VERBOSITY=UVM_DEBUG
# +UVM_VERBOSITY=UVM_HIGH
# +UVM_TESTNAME=

-voptargs=+acc=npr+/tb_top
-voptargs=+acc=npr+/tb_top/dut
-voptargs=+acc=npr+/tb_top/dut/network_i

-voptargs=+acc=npr+/tb_top/dut/network_i/block[0]/nb/neuron[1]/n