

IVERILOG = iverilog$(ICARUS_SUFFIX)
VVP = vvp$(ICARUS_SUFFIX)
PYTHON = python3


NAME = AIPCoprocessor_Module
AIPCOP_SRC = aip-coprocessor/
BASICBLOCKS = basicblocks/

# ---- PWM ----

	
synth: $(BASICBLOCKS)aip/aipModules.v $(BASICBLOCKS)memories/*.v  $(AIPCOP_SRC)src/aipCoprocessor.v  $(AIPCOP_SRC)simulation/aipTask.sv $(AIPCOP_SRC)simulation/aipCoprocessorTb2.sv
	#-- Compilar
	$(IVERILOG) -g2012 $^ -o $(NAME)_tb.out
	

sim:*.out
	#-- Simular
	vvp $(NAME)_tb.out
# ---- Clean ----

clean:
	rm -vrf *.vvp *.vvp *.vcd *.trace 


.PHONY: spiflash_tb clean

