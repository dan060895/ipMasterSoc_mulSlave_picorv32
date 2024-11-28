
CROSS=/opt/riscv/gcc14-no-zcmp/bin/riscv32-unknown-elf-
RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv/gcc14-no-zcmp
CFLAGS=
ICARUS_SUFFIX =
IVERILOG = iverilog$(ICARUS_SUFFIX)
VVP = vvp$(ICARUS_SUFFIX)
PYTHON = python3.11

TEST_OBJS = $(addsuffix .o,$(basename $(wildcard tests/*.S)))
FIRMWARE_OBJS = firmware/start.o firmware/irq.o firmware/print.o
GCC_WARNS  = -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings
GCC_WARNS += -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic # -Wconversion
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-
COMPRESSED_ISA = C

NAME = PICORV32_Module
IPDUMMY_SRC = ../mods/00001001/hdl/src/
PWM_SRC = ../../Modules/AIP_PWM/PWM/
GPIO_SRC = ../../Modules/AIP_GPIO/src/
UART_SRC = ../mods/UART_Builder/Sources/
BASICBLOCKS = ../mods/basicblocks/
MODULES= modules

# ---- FPGA IPDI Board -----------
PROJ=TOP_SOC
TOP=TOP_SOC_ipdiRDBv2
FPGA_PACKAGE=CABGA256#CABGA381
FPGA_TYPE=25k#85k
LPF=ipdiEDBv1#ipdiRDBv2_externBridge
VIDPID=i:0x0403:0x6010
INTERFACE=A

VERILOG_FILES:=$(shell cat ${PROJ}.ys | sed 's/.* //')



all : ${PROJ}.bit

syn : ${PROJ}.json ## Synthesis with Yosys

pnr : ${PROJ}.config ## Place & Route with nextpnr

bit : ${PROJ}.bit ## Bitstream with Project Trellis

%.json : ${VERILOG_FILES}
	rm -f ${PROJ}.ys.log
	yosys \
		-s ${PROJ}.ys \
		-l ${PROJ}.ys.log \
		-p "synth_ecp5 -abc9 -json ${PROJ}.json -top ${TOP}"

%.config : ${PROJ}.json 
	rm -f ${PROJ}.pnr.log
	nextpnr-ecp5 \
		--json ${PROJ}.json \
		--log ${PROJ}.pnr.log \
		--textcfg ${PROJ}.config \
		--${FPGA_TYPE} \
		--package ${FPGA_PACKAGE} \
		--lpf-allow-unconstrained \
		--lpf ${LPF}.lpf

%.bit : ${PROJ}.config 
	ecppack ${PROJ}.config ${PROJ}.bit
	ecppack --svf ${PROJ}.svf ${PROJ}.config ${PROJ}.bit

pRAM : ${PROJ}.bit ## Program FPGA RAM with ecpprog
	ecpprog -d $(VIDPID) -I $(INTERFACE) -S ${PROJ}.bit

pROM : ${PROJ}.bit ## Program FPGA ROM with ecpprog
	ecpprog -d $(VIDPID) -I $(INTERFACE) -a -X -b ${PROJ}.bit

dot : ## Create a top netlist
	yosys ${PROJ}.ys \
		-p "hierarchy -check -top $(TOP)" \
		-p "proc" \
		-p "opt" \
		-p "stat" \
		-p "select -module ${TOP}" \
		-p "show -prefix ${TOP} -notitle -colors 2 -width -stretch -format dot "
	xdot ${TOP}.dot

# ---- iCE40 IceBreaker Board ----

icebsim: icebreaker_tb.vvp icebreaker_fw.hex
	vvp -N $< +firmware=firmware/icebreaker_fw.hex

icebsim_max: max10_tb.vvp altera_out.txt
	vvp -N $< +firmware=firmware/altera_out.txt
	
test_aip_vcd: picoSoC_DDS_tb.vvp firmware/firmware.hex
	$(VVP) -N $< +vcd +trace +noerror
	
synth: $(BASICBLOCKS)memories/simple_dual_port_ram_single_clk.v $(BASICBLOCKS)aip/aipModules.v $(BASICBLOCKS)sequential/upCounter.v $(BASICBLOCKS)sequential/shiftRegister.v $(UART_SRC)*.v $(IPDUMMY_SRC)*.v $(PWM_SRC)src/*.v $(PWM_SRC)ID0000200e_files_pwm_module/*.v $(GPIO_SRC)*.v $(GPIO_SRC)ID0000100A_GPIO_aip/*.v testbench_dummy_picosoc_AIP.v native_aip.v ipdummy_picosoc.v picosoc_AIP.v ID0000200F_aip.v simpleuart.v picorv32.v
	#-- Compilar
	$(IVERILOG) $^ -o $(NAME)_tb.out
	
synth_soc: blinky.v $(BASICBLOCKS)memories/simple_dual_port_ram_single_clk.v $(BASICBLOCKS)aip/aipModules.v $(BASICBLOCKS)sequential/upCounter.v $(BASICBLOCKS)sequential/shiftRegister.v $(UART_SRC)*.v $(IPDUMMY_SRC)*.v $(PWM_SRC)src/*.v $(PWM_SRC)ID0000200e_files_pwm_module/*.v $(GPIO_SRC)*.v $(GPIO_SRC)ID0000100A_GPIO_aip/*.v testbench_dummy_picosoc_Builder.v native_aip.v builder_picosoc.v picosoc_ipdi.v ID0000200F_aip.v simpleuart.v picorv32_AIP.v picorv32.v
	#-- Compilar
	$(IVERILOG) $^ -o $(NAME)_tb.out

synth_soc2: blinky.v $(BASICBLOCKS)memories/simple_dual_port_ram_single_clk.v $(BASICBLOCKS)ipm/*.v $(BASICBLOCKS)aip/aipModules.v $(BASICBLOCKS)sequential/upCounter.v $(BASICBLOCKS)sequential/shiftRegister.v $(UART_SRC)*.v $(IPDUMMY_SRC)*.v $(PWM_SRC)src/*.v $(PWM_SRC)ID0000200e_files_pwm_module/*.v $(GPIO_SRC)*.v $(GPIO_SRC)ID0000100A_GPIO_aip/*.v testbench_TOP_SOC_ipdiRDBv2.v native_aip.v TOP_SOC_ipdiRDBv2.v builder_picosoc.v picosoc_ipdi.v ID0000200F_aip.v simpleuart.v picorv32_AIP.v picorv32.v
	#-- Compilar
	$(IVERILOG) $^ -o $(NAME)_tb.out

synth3:testbench_ez.v picorv32.v
	$(IVERILOG) -o $@ $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@
synth2: $(MODULES).ys 
	#-- Compilar
	$(IVERILOG) -g2012 -Wall -c $^ -o $(NAME)_tb.out
	
sim:*.out
	#-- Simular
	vvp $(NAME)_tb.out

sim_soc:*.out
	#-- Simular
	vvp $(NAME)_tb.out
	
picoSoC_DDS_tb.vvp: testbench_ipcore_AIP.v picorv32.v native_aip.v 
	$(IVERILOG) -v -c $(MODULES).ys -o $@ $^
	chmod -x $@
	
fpga_sections.lds: sections.lds
	$(CROSS)cpp -P -DICEBREAKER -o $@ $^

main_fw.elf: firmware/fpga_sections.lds firmware/print.c firmware/irqb.c firmware/start.S firmware/main.c
	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -o firmware/main_fw.elf firmware/start.S firmware/irqb.c firmware/print.c firmware/main.c
	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -S firmware/irqb.c
	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -S firmware/main.c


#main_fw.elf: firmware/fpga_sections.lds firmware/start.S firmware/irqb.s firmware/main.s
#	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -o firmware/main_fw.elf firmware/start.S firmware/irqb.s firmware/main.s
#	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -S firmware/irq.c
#	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -S firmware/main.c

#main_fw.elf: firmware/fpga_sections.lds firmware/start.s firmware/main.c
#	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -o firmware/main_fw.elf firmware/start.s firmware/main.c
#	$(CROSS)gcc $(CFLAGS) -DICEBREAKER -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,firmware/fpga_sections.lds,--strip-debug -ffreestanding -nostdlib -S firmware/main_fw.elf firmware/start.s firmware/main.c


main_fw.hex: main_fw.elf
	$(CROSS)objcopy -O verilog firmware/main_fw.elf firmware/main_fw.hex

main_fw.bin: firmware/main_fw.elf
	$(CROSS)objcopy -O binary firmware/main_fw.elf firmware/main_fw.bin


#firmware/main_fw.bin: firmware/main_fw.elf
#	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@
#	chmod -x $@

#firmware/main_fw.elf: $(FIRMWARE_OBJS) $(TEST_OBJS) firmware/fpga_sections.lds
#	$(TOOLCHAIN_PREFIX)gcc -Os -mabi=ilp32 -march=rv32im$(subst C,c,$(COMPRESSED_ISA)) -ffreestanding -nostdlib -o $@ \
#		-Wl,--build-id=none,-Bstatic,-T,firmware/fpga_sections.lds,-Map,firmware/main_fw.map,--strip-debug \
#		$(FIRMWARE_OBJS) $(TEST_OBJS) -lgcc
#	chmod -x $@

#firmware/start.o: firmware/start.S
#	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32im$(subst C,c,$(COMPRESSED_ISA)) -o $@ $<

#firmware/%.o: firmware/%.c
#	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i$(subst C,c,$(COMPRESSED_ISA)) -Os --std=c99 $(GCC_WARNS) -ffreestanding -nostdlib -o $@ $<

#main_fw.hex: firmware/main_fw.elf
#	$(CROSS)objcopy -O verilog firmware/main_fw.elf firmware/main_fw.hex

firmware/altera_out.txt: main_fw.hex firmware/main_fw.hex firmware/hextoMEM.py
	$(PYTHON) firmware/hextoMEM.py $@

runPICO: firmware/altera_out.txt 
	$(PYTHON) firmware/main_IPM_PICORV32.py $@	

        	
# ---- ASIC Synthesis Tests ----

cmos.log: spimemio.v simpleuart.v picosoc.v ../picorv32.v
	yosys -l cmos.log -p 'synth -top picosoc; abc -g cmos2; opt -fast; stat' $^

# ---- Clean ----

clean:
	rm -f testbench.vvp testbench.vcd spiflash_tb.vvp spiflash_tb.vcd *.out main.s irq.s *.bit *.config *.json *.pnr.log *.svf
	rm -f firmware/*.hex firmware/*.elf firmware/*.bin firmware/altera_out.txt
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS) check.smt2 check.vcd synth.v synth.log \
                firmware/*.elf firmware/*.bin firmware/*.hex firmware/*.map \
                testbench.vvp testbench_sp.vvp testbench_synth.vvp testbench_ez.vvp \
                *.vvp *.vvp testbench.vcd *.trace \
                testbench_verilator testbench_verilator_dir


.PHONY: spiflash_tb clean
.PHONY: hx8kprog hx8kprog_fw hx8ksim hx8ksynsim
.PHONY: icebprog icebprog_fw icebsim icebsynsim
