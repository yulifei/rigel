SRCS = $(wildcard *.lua)
SRCS := $(filter-out harness.lua examplescommon.lua pyramid_core.lua harris_core.lua sift_core.lua sift_core_hw.lua campipe_core.lua descriptor_core.lua  stereo_core.lua stereo_tr_core.lua  lk_core.lua lk_tr_core.lua,$(SRCS))


RIGEL_VERILATOR_INCLUDE ?= $(shell pkg-config --variable=includedir verilator)
RIGEL_VERILATOR_CFLAGS ?= $(shell pkg-config --cflags verilator)
LUA = ../rigelLuajit
TERRA = ../rigelTerra

RAWS = $(wildcard *.raw)
DUPS = $(patsubst %.raw,out/%.raw.dup,$(RAWS))

VERILOG = $(patsubst %.lua,out/%.v,$(SRCS))

# too slow
SRCS_TERRA = $(filter-out stereo_tr_rgba_full_32.lua stereo_ov7660.lua underflow.lua lk_wide_handshake_12_1_float.lua lk_wide_handshake_12_1_axi.lua lk_wide_handshake_12_1_axi_nostall.lua lk_tr_handshake_12_1_axi.lua lk_tr_handshake_12_2_axi.lua lk_tr_handshake_12_3_axi.lua lk_tr_handshake_12_4_axi.lua lk_tr_handshake_12_6_axi.lua lk_tr_handshake_12_12_axi.lua, $(SRCS))

# broken
SRCS_TERRA := $(filter-out sift_hw_1080p.lua sift_hw.lua, $(SRCS_TERRA))

TERRAOUT = $(patsubst %.lua,out/%.terra.raw,$(SRCS_TERRA))
TERRAOUT += $(patsubst %.lua,out/%_half.terra.raw,$(SRCS_TERRA))
TERRAOUT += $(patsubst %.lua,out/%.terra.bmp,$(SRCS_TERRA))
TERRAOUT += $(patsubst %.lua,out/%_half.terra.bmp,$(SRCS_TERRA))
TERRAOUT += $(patsubst %.lua,out/%.terra.correct.txt,$(SRCS_TERRA))
TERRAOUT += $(patsubst %.lua,out/%_half.terra.correct.txt,$(SRCS_TERRA))

# no support for xilinx prims needed for float
SRCS_VERILATOR = $(filter-out fixed_float_inv.lua fixed_float_sub.lua fixed_float_sqrt.lua fixed_float_gt.lua fixed_float_rshift.lua fixed_int_float.lua fixed_float_mult.lua fixed_float_add.lua  featuredescriptor.lua harris.lua harris_filterseq.lua harris_corner.lua sift_hw.lua sift_desc_hw.lua sift_hw_1080p.lua sift_float.lua lk_wide_handshake_12_1_float.lua lk_wide_handshake_4_4_float.lua lk_wide_handshake_6_4_float.lua sift_desc.lua, $(SRCS))

# uses Xilinx huge mult blocks - no support for prims
SRCS_VERILATOR := $(filter-out lk_tr_handshake_6_3_axi.lua lk_tr_handshake_6_6_axi.lua  lk_tr_handshake_6_2_axi.lua  lk_tr_handshake_6_1_axi.lua lk_tr_handshake_4_4_axi.lua lk_tr_handshake_4_1_axi.lua lk_tr_handshake_12_12_axi.lua  lk_tr_handshake_12_6_axi.lua lk_tr_handshake_12_4_axi.lua lk_tr_handshake_12_3_axi.lua lk_tr_handshake_12_2_axi.lua lk_tr_handshake_12_1_axi.lua lk_wide_handshake_12_1_axi.lua lk_wide_handshake_12_1_axi_nostall.lua  lk_wide_handshake_6_4_axi.lua lk_wide_handshake_6_1_axi.lua lk_wide_handshake_4_4_axi.lua lk_wide_handshake_4_1_axi.lua, $(SRCS_VERILATOR))

# verilator target doesn't include underflow block
SRCS_VERILATOR := $(filter-out underflow.lua, $(SRCS_VERILATOR))

# TODO: broken
SRCS_VERILATOR := $(filter-out stereo_tr_rgba_full_32.lua tmux_wide_handshake.lua pyramid_large_taps_3.lua pyramid_taps_4.lua pyramid_tr_3.lua, $(SRCS_VERILATOR))

# too slow for travis
SRCS_VERILATOR := $(filter-out stereo_wide_handshake_full.lua stereo_wide_handshake_nostall_full.lua, $(SRCS_VERILATOR))

# fails in travis for some reason?
SRCS_VERILATOR := $(filter-out stereo_wide_handshake_medi.lua stereo_wide_handshake_nostall_medi.lua, $(SRCS_VERILATOR))

VERILATOR = $(patsubst %.lua,out/%.verilator,$(SRCS_VERILATOR))
VERILATOR = $(patsubst %.lua,out/%.verilator.raw,$(SRCS_VERILATOR))
#VERILATOR += $(patsubst %.lua,out/%_half.raw,$(SRCS_VERILATOR))
VERILATOR += $(patsubst %.lua,out/%.verilator.bmp,$(SRCS_VERILATOR))
#VERILATOR += $(patsubst %.lua,out/%_half.bmp,$(SRCS_VERILATOR))
VERILATOR += $(patsubst %.lua,out/%.verilator.correct.txt,$(SRCS_VERILATOR))
#VERILATOR += $(patsubst %.lua,out/%_half.correct.txt,$(SRCS_VERILATOR))

# too slow
SRCS_TERRA_ISIM = $(SRCS_TERRA)
SRCS_TERRA_ISIM := $(filter-out stereo_wide_handshake_medi.t stereo_wide_handshake_nostall_medi.t stereo_tr_medi_4.t stereo_tr_medi_8.t stereo_tr_medi_16.t ,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out stereo_wide_handshake_full.t stereo_wide_handshake_nostall_full.t stereo_tr_full_4.t stereo_tr_full_8.t stereo_tr_full_16.t stereo_tr_rgba_full_32.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out stereo_ov7660.t ,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out lk_wide_handshake_4_4_float.t lk_wide_handshake_6_4_axi.t lk_wide_handshake_6_4_float.t lk_wide_handshake_6_1_axi.t lk_wide_handshake_4_4_axi.t lk_wide_handshake_4_1_axi.t lk_tr_handshake_4_4_axi.t lk_tr_handshake_6_6.t lk_tr_handshake_6_6_axi.t lk_tr_handshake_6_1.t lk_tr_handshake_6_1_axi.t lk_tr_handshake_6_2.t lk_tr_handshake_6_2_axi.t lk_tr_handshake_6_3.t lk_tr_handshake_6_3_axi.t ,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out lk_wide_handshake_12_1_float.t lk_wide_handshake_12_1_axi.t lk_wide_handshake_12_1_axi_nostall.t lk_tr_handshake_12_1_axi.t lk_tr_handshake_12_2_axi.t lk_tr_handshake_12_3_axi.t lk_tr_handshake_12_4_axi.t lk_tr_handshake_12_6_axi.t lk_tr_handshake_12_12_axi.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out campipe_512.t campipe_ov7660.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out pyramid_large_1.t pyramid_large_2.t pyramid_large_3.t pyramid_large_4.t pyramid_large_tr_1.t pyramid_large_tr_2.t pyramid_large_tr_3.t pyramid_large_tr_4.t pyramid_large_nofifo_tr_1.t pyramid_large_nofifo_tr_2.t pyramid_large_nofifo_tr_3.t pyramid_large_nofifo_tr_4.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out pyramid_large_taps_1.t pyramid_large_taps_2.t pyramid_large_taps_3.t pyramid_large_taps_4.t pyramid_large_nofifo_taps_1.t pyramid_large_nofifo_taps_2.t pyramid_large_nofifo_taps_3.t pyramid_large_nofifo_taps_4.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out convpadcrop_wide_handshake_4_1_1080p.t convpadcrop_wide_handshake_4_2_1080p.t convpadcrop_wide_handshake_4_4_1080p.t convpadcrop_wide_handshake_4_8_1080p.t convpadcrop_wide_handshake_8_1_1080p.t convpadcrop_wide_handshake_8_2_1080p.t convpadcrop_wide_handshake_8_4_1080p.t convpadcrop_wide_handshake_8_8_1080p.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out convpadcrop_wide_handshake_8_1_1080p_nostall.t convpadcrop_wide_handshake_8_2_1080p_nostall.t convpadcrop_wide_handshake_8_4_1080p_nostall.t convpadcrop_wide_handshake_8_8_1080p_nostall.t,$(SRCS_TERRA_ISIM))
SRCS_TERRA_ISIM := $(filter-out conv_tr_handshake_4_1_1080p.t conv_tr_handshake_4_2_1080p.t conv_tr_handshake_4_4_1080p.t conv_tr_handshake_4_8_1080p.t conv_tr_handshake_8_1_1080p.t conv_tr_handshake_8_2_1080p.t conv_tr_handshake_8_4_1080p.t conv_tr_handshake_8_8_1080p.t,$(SRCS_TERRA_ISIM))
#nyi
SRCS_TERRA_ISIM := $(filter-out fixed_float_inv.t harris_corner.t filterseq.t harris_filterseq.t sift_float.t sift_desc.t sift_desc_hw.t sift_hw.t sift_hw_1080p.t,$(SRCS_TERRA_ISIM))

ISIM = $(patsubst %.lua,out/%.isim.bmp,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%.isim.1.bmp,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%_half.isim.bmp,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%.isim.raw,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%_half.isim.raw,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%.isim.v,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%_half.isim.v,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%.isim.correct.txt,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%.isim.1.correct.txt,$(SRCS_TERRA_ISIM))
ISIM += $(patsubst %.lua,out/%_half.isim.correct.txt,$(SRCS_TERRA_ISIM))

SRCS_AXI = $(filter-out linebufferpartial_handshake_1.lua linebufferpartial_handshake_2.lua linebufferpartial_handshake_4.lua convpadcrop_handshake.lua reduceseq_handshake.lua  stereo_wide_handshake_medi.lua,$(SRCS))
SRCS_AXI := $(filter-out lk_tr_handshake_4_4.lua lk_tr_handshake_6_6.lua lk_tr_handshake_6_1.lua lk_tr_handshake_6_2.lua lk_tr_handshake_6_3.lua lk_wide_handshake_12_1_float.lua,$(SRCS_AXI))
SRCS_AXI := $(filter-out lk_wide_handshake_4_4_float.lua lk_wide_handshake_6_4_float.lua lk_wide_handshake_4_4.lua lk_wide_handshake_4_1.lua,$(SRCS_AXI))
SRCS_AXI := $(filter-out harris_filterseq.lua sift_float.lua sift_desc.lua,$(SRCS_AXI))

# fails in the cron script b/c par takes too long
SRCS_AXI := $(filter-out convpadcrop_wide_handshake_8_8.lua lk_wide_handshake_4_4_axi.lua lk_tr_handshake_12_3_axi.lua,$(SRCS_AXI))

# TODO fix: fails in cron due to taking too many cycles to execute?
SRCS_AXI := $(filter-out upsample_wide_handshake_2.lua upsample_wide_handshake_4.lua tmux_wide_handshake.lua edge_taps.lua,$(SRCS_AXI))

# broken tests
SRCS_AXI := $(filter-out fixed_float_inv.lua sift_desc_hw.lua sift_hw.lua sift_hw_1080p.lua featuredescriptor.lua,$(SRCS_AXI))

# NYI - type size not a factor of axi bus size
SRCS_AXI := $(filter-out 4bpp.lua 12bpp.lua 18bpp.lua,$(SRCS_AXI))

SRCS_AXI100 = $(SRCS_AXI)

# Broken due to 'too many cycles' bug
SRCS_AXI100 := $(filter-out 2xov7660.lua convolve_p8.lua convpadcrop_wide_handshake_4_2.lua convpadcrop_wide_handshake_4_4_1080p.lua convpadcrop_wide_handshake_8_2_1080p_nostall.lua edge.lua fifo_wide_handshake_2.lua lk_wide_handshake_4_1_axi.lua inv_wide_handshake.lua pyramid_large_1.lua pyramid_large_2.lua pyramid_large_4.lua lk_tr_handshake_12_1_axi.lua convpadcrop_wide_handshake_8_4_1080p.lua lk_tr_handshake_6_1_axi.lua pyramid_large_nofifo_taps_2.lua pyramid_large_taps_4.lua pyramid_large_tr_2.lua pyramid_large_tr_4.lua lk_tr_handshake_6_2_axi.lua,$(SRCS_AXI100))

# fails in PAR b/c takes too long or something?
SRCS_AXI100 := $(filter-out  stereo_tr_full_4.lua stereo_tr_medi_4.lua lk_tr_handshake_12_2_axi.lua, $(SRCS_AXI100))

# filter out stuff that's too big for the 7020
SRCS_AXI20 = $(SRCS_AXI)
SRCS_AXI20 := $(filter-out stereo_wide_handshake_nostall_full.lua stereo_wide_handshake_nostall_medi.lua stereo_wide_handshake_full.lua,$(SRCS_AXI20))
SRCS_AXI20 := $(filter-out lk_tr_handshake_12_1_axi.lua lk_tr_handshake_12_2_axi.lua lk_tr_handshake_12_3_axi.lua lk_tr_handshake_12_4_axi.lua lk_tr_handshake_12_6_axi.lua lk_tr_handshake_6_1_axi.lua lk_wide_handshake_4_4_axi.lua lk_wide_handshake_6_4_axi.lua,$(SRCS_AXI20))
SRCS_AXI20 := $(filter-out lk_wide_handshake_12_1_axi_nostall.lua lk_wide_handshake_12_1_axi.lua,$(SRCS_AXI20))
SRCS_AXI20 := $(filter-out pyramid_large_nofifo_taps_4.lua pyramid_large_taps_3.lua pyramid_taps_3.lua pyramid_taps_4.lua pyramid_large_taps_4.lua,$(SRCS_AXI20))

# fails due to size in cron script?
SRCS_AXI20 := $(filter-out convpadcrop_wide_handshake_8_8_1080p_nostall.lua pyramid_large_nofifo_taps_3.lua convpadcrop_wide_handshake_8_8_1080p.lua,$(SRCS_AXI20))

# TODO broken in cron script?
SRCS_AXI20 := $(filter-out edge.lua upsampley_wide_handshake.lua pointwise_wide_handshake_1080p.lua,$(SRCS_AXI20))

AXIVERILOG = $(patsubst %.lua,out/%.axi.v,$(SRCS_AXI))

AXIBITS = $(patsubst %.lua,out/%.axi.bit,$(SRCS_AXI20))

AXIBITS100 = $(patsubst %.lua,out/%.zynq100.bit,$(SRCS_AXI100))
AXIBITS100 += $(patsubst %.lua,out/%.zynq100.bit.bin,$(SRCS_AXI100))

AXI = $(patsubst %.lua,out/%.axi.raw,$(SRCS_AXI20))
AXI += $(patsubst %.lua,out/%.axi.bmp,$(SRCS_AXI20))
AXI += $(patsubst %.lua,out/%.axi.correct.txt,$(SRCS_AXI20))
AXI += $(patsubst %.lua,out/%.hz.txt,$(SRCS_AXI20))
AXI += $(AXIBITS)

AXI100 = $(patsubst %.lua,out/%.zynq100.correct.txt,$(SRCS_AXI100))
AXI100 += $(patsubst %.lua,out/%.zynq100.raw,$(SRCS_AXI100))
AXI100 += $(patsubst %.lua,out/%.zynq100.bmp,$(SRCS_AXI100))
AXI100 += $(AXIBITS100)

STATS = $(patsubst %.lua,out/%.stats.txt,$(AXISRCS))

STATS100 = $(patsubst %.lua,out/%.stats100.txt,$(SRCS_AXI100))

CAMERASRCS = stereo_ov7660.t 2xov7660.t campipe_ov7660.t
CAMERABITS = $(patsubst %.t,out/%.axi.v,$(CAMERASRCS))
CAMERABITS += $(patsubst %.t,out/%.camera.bit,$(CAMERASRCS))

SRCS_ASIC = $(SRCS_VERILATOR)

ASIC = $(patsubst %.lua, out/%.32nm.txt, $(SRCS_ASIC))

RES = $(TERRAOUT)
RES += $(VERILATOR)
RES += $(ISIM)
RES += $(AXI)
RES += $(AXIBITS)
RES += $(AXI100)
RES += $(AXIBITS100)
RES += $(ASIC)

CD = cd out;
all: $(RES)

# keep make from deleting these intermediates
.SECONDARY:

dups: $(DUPS)

verilog: $(VERILOG)

terra: $(TERRAOUT)

verilator: $(VERILATOR)

isim: $(ISIM)

stats: $(STATS)

stats100: $(STATS100)

zynq20: $(AXI)

camerabits: $(CAMERABITS)

zynq100: $(AXI100)

axiverilog: $(AXIVERILOG)

zynq20bits: $(AXIBITS)

zynq100bits: $(AXIBITS100)

asic: $(ASIC)

clean:
	rm -Rf out/*

out/%.v out/%.metadata.lua: %.lua
	$(LUA) $<
	# keep copy for future reference
	mkdir -p out/build_$*
	- cp out/$*.v out/build_$*

out/%.terra.raw out/%_half.terra.raw: %.lua
	$(TERRA) $< terrasim
	# keep copy for future reference
	mkdir -p out/build_$*
	#- cp out/$*.cycles.txt out/build_$*

out/%.isim.v out/%_half.isim.v: %.lua
	$(LUA) $< isim
	# keep copy for future reference
	mkdir -p out/build_$*
	- cp out/$*.isim.v out/build_$*

out/%.axi.v: %.lua
	$(LUA) $< axi
	# keep copy for future reference
	mkdir -p out/build_$*
	- cp out/$*.axi.v out/build_$*
	mkdir -p out/build100_$*
	- cp out/$*.axi.v out/build100_$*

#/opt/Xilinx/14.5/ISE_DS/ISE/verilog/src/unisims
#	verilator -cc -Mdir out/$*_verilator  /opt/Xilinx/14.5/ISE_DS/ISE/verilog/src/unisims/RAMB16_S36_S36.v out/$*.verilator.v
out/%.verilator: out/%.v out/%.metadata.lua ../platform/verilator/harness.cpp
	$(eval $@_TOP := $(shell luajit ../misc/extractMetadata.lua out/$*.metadata.lua topModule))
	verilator -cc -Mdir out/$*_verilator out/$*.v ../platform/verilator/RAM128X1D.v ../platform/verilator/RAMB16_S36_S36.v ../platform/verilator/RAMB16_S18_S18.v ../platform/verilator/RAMB16_S9_S9.v ../platform/verilator/RAMB16_RIGEL.v --top-module $($@_TOP)
#	$(LUA) ../platform/verilator/makeHarness.lua out/$*.metadata.lua $* > out/$*.verilator.cpp
	g++ ${RIGEL_VERILATOR_CFLAGS} -I. -DVERILATORCLASS="V$($@_TOP)" -DVERILATORFILE="\"out/$*_verilator/V$($@_TOP).h\"" out/$*_verilator/V$($@_TOP).cpp out/$*_verilator/V$($@_TOP)__Syms.cpp ${RIGEL_VERILATOR_INCLUDE}/verilated.cpp ../platform/verilator/harness.cpp -o $@

out/%.verilator.raw: out/%.verilator
	$(eval $@_INPUT := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputImage))
	$(eval $@_OUTW := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputWidth))
	$(eval $@_OUTH := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputHeight))
	$(eval $@_OUTBPP := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputBitsPerPixel))
	$(eval $@_OUTP := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputP))
	$(eval $@_INW := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputWidth))
	$(eval $@_INH := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputHeight))
	$(eval $@_INBPP := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputBitsPerPixel))
	$(eval $@_INP := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputP))
	$(eval $@_TAPBITS := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua tapBits))
	$(eval $@_TAPVALUE := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua tapValue))
	./out/$*.verilator $($@_INPUT) $@ $($@_INW) $($@_INH)  $($@_INBPP) $($@_INP) $($@_OUTW) $($@_OUTH) $($@_OUTBPP) $($@_OUTP) $($@_TAPBITS) $($@_TAPVALUE)

out/%.verilator.bmp: out/%.verilator.raw out/%.metadata.lua
	$(LUA) ../misc/raw2bmp.lua out/$*.verilator.raw out/$*.verilator.bmp out/$*.metadata.lua 0
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*.verilator.bmp out/build_$*

out/%.verilator.correct.txt : out/%.verilator.bmp
	diff out/$*.verilator.bmp gold/$*.bmp > out/$*.verilator.diff
	test ! -s out/$*.verilator.diff && touch $@
	# keep copy for future reference
#	mkdir -p out/build_$*
#	test ! -s out/$*.verilator.diff && touch $@

out/build_%/system.ngc: out/%.axi.v
	mkdir -p out/build_$*
	# run xst, then 'help -arch zynq -command run' to get list of options
	cd out/build_$*; echo "run -ifn ../$*.axi.v -ifmt Verilog -p xc7z020-clg484-1 -top stage -use_dsp48 No -ofn system" | xst > OUT_xst.txt

out/build_%/system.ngd: out/build_%/system.ngc
	cd out/build_$*; ngdbuild -nt timestamp -uc ../../../platform/axi/ps7_constraints.ucf -uc ../../../platform/axi/system.ucf -p xc7z020-clg484-1 system.ngc system.ngd > OUT_ngd.txt

out/build_%/system_map.ncd: out/build_%/system.ngd
	cd out/build_$*; map -detail -p xc7z020-clg484-1 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -mt off -ir off -pr off -lc off -power off -o system_map.ncd system.ngd system.pcf > OUT_map.txt

out/build_%/system.ncd: out/build_%/system_map.ncd
	cd out/build_$*; par -w -ol high -mt off system_map.ncd system.ncd system.pcf > OUT_par.txt

out/build_%/system.twr: out/build_%/system.ncd
	cd out/build_$*; trce -v 3 -s 1 -n 3 -fastpaths -xml system.twx system.ncd -o system.twr system.pcf -ucf ../../platform/axi/ps7_constraints.ucf -ucf ../../platform/axi/system.ucf > OUT_trce.txt

out/%.axi.bit: out/build_%/system.twr
	cd out/build_$*; bitgen -w -g Binary:no -g CRC:Enable -g ProgPin:PullUp -g InitPin:Pullup -g TckPin:PullUp -g TdiPin:PullUp \
	  -g TdoPin:PullUp -g TmsPin:PullUp -g Disable_JTAG:No -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g OverTempPowerDown:Disable \
	  -g USR_ACCESS:None -g JTAG_XADC:Enable -g DCIUpdateMode:AsRequired -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 \
	  -g Match_cycle:Auto -g Security:None -g ICAP_select:Auto -g DonePipe:Yes -g DriveDone:No system.ncd > OUT_bitgen.txt
	cp out/build_$*/system.bit $@


out/%.camera.bit: out/%.axi.v
	mkdir -p out/buildcamera_$*
	echo "verilog work \"../$*.axi.v\"" > out/buildcamera_$*/system.prj
	echo "verilog work \"../../../platform/camera/vsrc/*.v\"" >> out/buildcamera_$*/system.prj
	cp ../platform/camera/vsrc/*.ngc out/buildcamera_$*/.
	cd out/buildcamera_$*; xst -ifn ../../../platform/camera/system.xst  | tee OUT_xst.log
	cd out/buildcamera_$*; ngdbuild -nt timestamp -uc ../../../platform/camera/ps7_constraints.ucf -uc ../../../platform/camera/system.ucf -p xc7z020-clg484-1 system.ngc system.ngd | tee OUT_ngd.log
	cd out/buildcamera_$*; map -detail -p xc7z020-clg484-1 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -mt off -ir off -pr off -lc off -power off -o system_map.ncd system.ngd system.pcf > OUT_map.txt
	cd out/buildcamera_$*; par -w -ol high -mt off system_map.ncd system.ncd system.pcf > OUT_par.txt
	cd out/buildcamera_$*; trce -v 3 -s 1 -n 3 -fastpaths -xml system.twx system.ncd -o system.twr system.pcf -ucf ../../platform/axi/ps7_constraints.ucf -ucf ../../platform/axi/system.ucf > OUT_trce.txt
	cd out/buildcamera_$*; bitgen -w -g Binary:no -g CRC:Enable -g ProgPin:PullUp -g InitPin:Pullup -g TckPin:PullUp -g TdiPin:PullUp \
	  -g TdoPin:PullUp -g TmsPin:PullUp -g Disable_JTAG:No -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g OverTempPowerDown:Disable \
	  -g USR_ACCESS:None -g JTAG_XADC:Enable -g DCIUpdateMode:AsRequired -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 \
	  -g Match_cycle:Auto -g Security:None -g ICAP_select:Auto -g DonePipe:Yes -g DriveDone:No system.ncd > OUT_bitgen.txt
	cp out/buildcamera_$*/system.bit $@

out/%.camera1x.bit: out/%.axi.v
	mkdir -p out/buildcamera_$*
	echo "verilog work \"../$*.axi.v\"" > out/buildcamera_$*/system.prj
	echo "verilog work \"../../../platform/camera1x/vsrc/*.v\"" >> out/buildcamera_$*/system.prj
	cp ../platform/camera1x/vsrc/*.ngc out/buildcamera_$*/.
	cd out/buildcamera_$*; xst -ifn ../../../platform/camera/system.xst  | tee OUT_xst.log
	cd out/buildcamera_$*; ngdbuild -nt timestamp -uc ../../../platform/camera/ps7_constraints.ucf -uc ../../../platform/camera1x/system.ucf -p xc7z020-clg484-1 system.ngc system.ngd | tee OUT_ngd.log
	cd out/buildcamera_$*; map -detail -p xc7z020-clg484-1 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -mt off -ir off -pr off -lc off -power off -o system_map.ncd system.ngd system.pcf > OUT_map.txt
	cd out/buildcamera_$*; par -w -ol high -mt off system_map.ncd system.ncd system.pcf > OUT_par.txt
	cd out/buildcamera_$*; trce -v 3 -s 1 -n 3 -fastpaths -xml system.twx system.ncd -o system.twr system.pcf -ucf ../../platform/axi/ps7_constraints.ucf -ucf ../../platform/axi/system.ucf > OUT_trce.txt
	cd out/buildcamera_$*; bitgen -w -g Binary:no -g CRC:Enable -g ProgPin:PullUp -g InitPin:Pullup -g TckPin:PullUp -g TdiPin:PullUp \
	  -g TdoPin:PullUp -g TmsPin:PullUp -g Disable_JTAG:No -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g OverTempPowerDown:Disable \
	  -g USR_ACCESS:None -g JTAG_XADC:Enable -g DCIUpdateMode:AsRequired -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 \
	  -g Match_cycle:Auto -g Security:None -g ICAP_select:Auto -g DonePipe:Yes -g DriveDone:No system.ncd > OUT_bitgen.txt
	cp out/buildcamera_$*/system.bit $@

out/%.camera2.0.bit: out/%.axi.v
	mkdir -p out/buildcamera_$*
	echo "verilog work \"../$*.axi.v\"" > out/buildcamera_$*/system.prj
	echo "verilog work \"../../../platform/camera2.0/vsrc/*.v\"" >> out/buildcamera_$*/system.prj
	cp ../platform/camera2.0/vsrc/*.ngc out/buildcamera_$*/.
	cd out/buildcamera_$*; xst -ifn ../../../platform/camera/system.xst  | tee OUT_xst.log
	cd out/buildcamera_$*; ngdbuild -nt timestamp -uc ../../../platform/camera/ps7_constraints.ucf -uc ../../../platform/camera2.0/system.ucf -p xc7z020-clg484-1 system.ngc system.ngd | tee OUT_ngd.log
	cd out/buildcamera_$*; map -detail -p xc7z020-clg484-1 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -mt off -ir off -pr off -lc off -power off -o system_map.ncd system.ngd system.pcf > OUT_map.txt
	cd out/buildcamera_$*; par -w -ol high -mt off system_map.ncd system.ncd system.pcf > OUT_par.txt
	cd out/buildcamera_$*; trce -v 3 -s 1 -n 3 -fastpaths -xml system.twx system.ncd -o system.twr system.pcf -ucf ../../platform/axi/ps7_constraints.ucf -ucf ../../platform/axi/system.ucf > OUT_trce.txt
	cd out/buildcamera_$*; bitgen -w -g Binary:no -g CRC:Enable -g ProgPin:PullUp -g InitPin:Pullup -g TckPin:PullUp -g TdiPin:PullUp \
	  -g TdoPin:PullUp -g TmsPin:PullUp -g Disable_JTAG:No -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g OverTempPowerDown:Disable \
	  -g USR_ACCESS:None -g JTAG_XADC:Enable -g DCIUpdateMode:AsRequired -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 \
	  -g Match_cycle:Auto -g Security:None -g ICAP_select:Auto -g DonePipe:Yes -g DriveDone:No system.ncd > OUT_bitgen.txt
	cp out/buildcamera_$*/system.bit $@


CAMERA_ADDR=192.168.42.50
CAMERA_WRITE_PATH=/tmp
CAMERA_PASS=1234

%.camera.run: out/%.camera.bit
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo '100000000' > /sys/class/fclk/fclk0/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat /sys/class/fclk/fclk0/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo '96000000' > /sys/class/fclk/fclk1/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat /sys/class/fclk/fclk1/set_rate"
###### CLOCK STUFF END
	sshpass -p $(CAMERA_PASS) scp ../platform/camera/csrc/processimage out/$*.camera.bit root@$(CAMERA_ADDR):$(CAMERA_WRITE_PATH)/.
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat $(CAMERA_WRITE_PATH)/$*.camera.bit > /dev/xdevcfg"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "$(CAMERA_WRITE_PATH)/processimage 0" 
	-sshpass -p $(CAMERA_PASS) scp root@$(CAMERA_ADDR):$(CAMERA_WRITE_PATH)/*.raw .
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "rm $(CAMERA_WRITE_PATH)/processimage $(CAMERA_WRITE_PATH)/$*.camera.bit"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport"

%.camera1x.run: out/%.camera1x.bit
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo '100000000' > /sys/class/fclk/fclk0/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat /sys/class/fclk/fclk0/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo '96000000' > /sys/class/fclk/fclk1/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat /sys/class/fclk/fclk1/set_rate"
###### CLOCK STUFF END
	sshpass -p $(CAMERA_PASS) scp ../platform/camera1x/csrc/processimage out/$*.camera1x.bit root@$(CAMERA_ADDR):$(CAMERA_WRITE_PATH)/.
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat $(CAMERA_WRITE_PATH)/$*.camera1x.bit > /dev/xdevcfg"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "$(CAMERA_WRITE_PATH)/processimage 0" 
	-sshpass -p $(CAMERA_PASS) scp root@$(CAMERA_ADDR):$(CAMERA_WRITE_PATH)/*.raw .
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "rm $(CAMERA_WRITE_PATH)/processimage $(CAMERA_WRITE_PATH)/$*.camera1x.bit"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport"

%.camera2.0.run: out/%.camera2.0.bit
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo '100000000' > /sys/class/fclk/fclk0/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat /sys/class/fclk/fclk0/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo '96000000' > /sys/class/fclk/fclk1/set_rate"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat /sys/class/fclk/fclk1/set_rate"
###### CLOCK STUFF END
	sshpass -p $(CAMERA_PASS) scp ../platform/camera2.0/csrc/processimage out/$*.camera2.0.bit root@$(CAMERA_ADDR):$(CAMERA_WRITE_PATH)/.
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "cat $(CAMERA_WRITE_PATH)/$*.camera2.0.bit > /dev/xdevcfg"
	sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "$(CAMERA_WRITE_PATH)/processimage 0" 
	-sshpass -p $(CAMERA_PASS) scp root@$(CAMERA_ADDR):$(CAMERA_WRITE_PATH)/*.raw .
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "rm $(CAMERA_WRITE_PATH)/processimage $(CAMERA_WRITE_PATH)/$*.camera2.0.bit"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport"
	-sshpass -p $(CAMERA_PASS) ssh root@$(CAMERA_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport"

out/%_zynq100/system.ngc: out/%.axi.v
	mkdir -p out/$*_zynq100
	# run xst, then 'help -arch zynq -command run' to get list of options
	cd out/$*_zynq100; echo "run -ifn ../$*.axi.v -ifmt Verilog -p xc7z100-2ffg900 -top stage -use_dsp48 No -ofn system" | xst > OUT_xst.txt

out/%_zynq100/system.ngd: out/%_zynq100/system.ngc
	cd out/$*_zynq100; ngdbuild -nt timestamp -uc ../../../platform/axi/ps7_constraints_100.ucf -uc ../../../platform/axi/system_100.ucf -p xc7z100-2ffg900  system.ngc system.ngd > OUT_ngd.txt

out/%_zynq100/system_map.ncd: out/%_zynq100/system.ngd
	cd out/$*_zynq100; map -detail -p xc7z100-2ffg900 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -mt off -ir off -pr off -lc off -power off -o system_map.ncd system.ngd system.pcf > OUT_map.txt

out/%_zynq100/system.ncd: out/%_zynq100/system_map.ncd
	cd out/$*_zynq100; par -w -ol high -mt off system_map.ncd system.ncd system.pcf > OUT_par.txt

out/%_zynq100/system.twr: out/%_zynq100/system.ncd
	cd out/$*_zynq100; trce -v 3 -s 1 -n 3 -fastpaths -xml system.twx system.ncd -o system.twr system.pcf -ucf ../../platform/axi/ps7_constraint_100s.ucf -ucf ../../platform/axi/system_100.ucf > OUT_trce.txt

out/%.zynq100.bit: out/%_zynq100/system.twr
	cd out/$*_zynq100; bitgen -w -g Binary:no -g CRC:Enable -g ProgPin:PullUp -g InitPin:Pullup -g TckPin:PullUp -g TdiPin:PullUp \
	  -g TdoPin:PullUp -g TmsPin:PullUp -g Disable_JTAG:No -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g OverTempPowerDown:Disable \
	  -g USR_ACCESS:None -g JTAG_XADC:Enable -g DCIUpdateMode:AsRequired -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 \
	  -g Match_cycle:Auto -g Security:None -g ICAP_select:Auto -g DonePipe:Yes -g DriveDone:No system.ncd > OUT_bitgen.txt
	cp out/$*_zynq100/system.bit $@

out/%.zynq100.bit.bin: out/%.zynq100.bit
	cd out/$*_zynq100; bootgen -w -image ../../../platform/axi/boot.bif -split bin -o i system.bin
	cp out/$*_zynq100/system.bit.bin $@

ZYNQ_WRITE_PATH=/var/volatile
ZYNQ_ADDR=192.168.2.2

out/%.hz.txt: out/%.axi.bit
	$(eval $@_HZl := $(shell grep Maximum out/build_$*/OUT_trce.txt  | grep -P -o "[0-9.]+" | tail -1 | tr -d '\n' | awk '{print $$1" * 1000000"}' | bc -l | xargs printf "%d"))
	echo $($@_HZl) > out/$*.hz.txt

out/%.axi.raw: out/%.axi.bit out/%.hz.txt out/%.metadata.lua
	$(eval $@_IMG := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputImage))
	$(eval $@_INW := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputWidth))
	$(eval $@_INH := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputHeight))
	$(eval $@_BPP_IN := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputBitsPerPixel))
	$(eval $@_BPP_OUT := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputBitsPerPixel))
	$(eval $@_OUTW := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputWidth))
	$(eval $@_OUTH := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputHeight))
###### SET THE CLOCK	
	$(eval $@_HZ := $(shell cat out/$*.hz.txt))
	lockfile /tmp/zynq20lock
# (* second time around we can't write to fclk_export, so surpress error)
#	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export"
	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "if [[ ! -a /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk/fclk0 ]]; then echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export; fi"
	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "echo '$($@_HZ)' > /sys/class/fclk/fclk0/set_rate"
	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "cat /sys/class/fclk/fclk0/set_rate" > out/$*.realhz.txt
###### CLOCK STUFF END
	sshpass -p 'root' scp ../platform/axi/processimage out/$*.axi.bit $($@_IMG) root@$(ZYNQ_ADDR):$(ZYNQ_WRITE_PATH)
	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "cat $(ZYNQ_WRITE_PATH)/$*.axi.bit > /dev/xdevcfg"
	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "$(ZYNQ_WRITE_PATH)/processimage 805339136 $(ZYNQ_WRITE_PATH)/$($@_IMG) $(ZYNQ_WRITE_PATH)/out.raw $($@_INW) $($@_INH) $($@_BPP_IN) $($@_OUTW) $($@_OUTH) $($@_BPP_OUT) "
	sshpass -p 'root' scp root@$(ZYNQ_ADDR):$(ZYNQ_WRITE_PATH)/out.raw out/$*.axi.raw
	sshpass -p 'root' ssh root@$(ZYNQ_ADDR) "rm $(ZYNQ_WRITE_PATH)/processimage $(ZYNQ_WRITE_PATH)/$($@_IMG) $(ZYNQ_WRITE_PATH)/out.raw $(ZYNQ_WRITE_PATH)/$*.axi.bit"
	rm -f /tmp/zynq20lock
	$(TERRA) ../misc/extractCycles.t out/$*.axi.raw > out/$*.axi.cycles.txt
	# keep copy for future reference
	cp out/$*.axi.cycles.txt out/build_$*


ZYNQ_100_WRITE_PATH=/tmp
ZYNQ_100_ADDR=192.168.1.10

out/%.zynq100.raw: out/%.zynq100.bit.bin out/%.metadata.lua
	$(eval $@_IMG := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputImage))
	$(eval $@_INW := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputWidth))
	$(eval $@_INH := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputHeight))
	$(eval $@_BPP_IN := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua inputBitsPerPixel))
	$(eval $@_BPP_OUT := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputBitsPerPixel))
	$(eval $@_OUTW := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputWidth))
	$(eval $@_OUTH := $(shell $(LUA) ../misc/extractMetadata.lua out/$*.metadata.lua outputHeight))
	lockfile /tmp/zynq100lock
	# kill the DMA test that runs in the background and takes up 100% cpu (!?)
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "chmod a+w /sys/module/dmatest/parameters/iterations"
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "echo 1 > /sys/module/dmatest/parameters/iterations"
	printf "cd /tmp\n put ../platform/axi/processimage\n put out/$*.zynq100.bit.bin\n put $($@_IMG)" | sshpass -p 'root' sftp root@$(ZYNQ_100_ADDR)
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "rm -f /dev/xdevcfg"
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "mknod /dev/xdevcfg c 259 0"
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "cat $(ZYNQ_100_WRITE_PATH)/$*.zynq100.bit.bin > /dev/xdevcfg"
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "$(ZYNQ_100_WRITE_PATH)/processimage 805339136 $(ZYNQ_100_WRITE_PATH)/$($@_IMG) $(ZYNQ_100_WRITE_PATH)/out.raw $($@_INW) $($@_INH) $($@_BPP_IN) $($@_OUTW) $($@_OUTH) $($@_BPP_OUT) "
	printf "cd /tmp\n get out.raw $@" | sshpass -p 'root' sftp root@$(ZYNQ_100_ADDR)
	sshpass -p 'root' ssh root@$(ZYNQ_100_ADDR) "rm $(ZYNQ_100_WRITE_PATH)/processimage $(ZYNQ_100_WRITE_PATH)/$($@_IMG) $(ZYNQ_100_WRITE_PATH)/out.raw $(ZYNQ_100_WRITE_PATH)/$*.zynq100.bit.bin"
	rm -f /tmp/zynq100lock
	$(TERRA) ../misc/extractCycles.t out/$*.zynq100.raw > out/$*.zynq100.cycles.txt
	# keep copy for future reference
	cp out/$*.zynq100.cycles.txt out/$*_zynq100

# isim is crap, and if we run multiple processes at the same time in the same directory, they will clobber each other. So we need to run in different directories.
out/%.isim.raw: out/%.isim.v $(DUPS)
	mkdir -p out/sim_$*
	cd out/sim_$*; vlogcomp ../$*.isim.v
	cd out/sim_$*; fuse -o $* -lib $* -L unisim -L unimacro -top sim
	cd out/sim_$*; echo "run all" | ./$* > output.txt
	split -n 2 -d out/sim_$*/$*.isim.raw out/sim_$*/S
	mv out/sim_$*/S00 out/$*.isim.raw
	mv out/sim_$*/S01 out/$*.isim.1.raw
	$(TERRA) ../misc/extractCycles.t out/$*.isim.raw > out/$*.isim.cycles.txt
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*.isim.cycles.txt out/build_$*

out/%.isim.bmp: out/%.isim.raw out/%.metadata.lua
	$(LUA) ../misc/raw2bmp.lua out/$*.isim.raw out/$*.isim.bmp out/$*.metadata.lua 1
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*.isim.bmp out/build_$*

out/%.isim.1.bmp: out/%.isim.raw out/%.metadata.lua
	$(LUA) ../misc/raw2bmp.lua out/$*.isim.1.raw out/$*.isim.1.bmp out/$*.metadata.lua 1
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*.isim.1.bmp out/build_$*

out/%.axi.bmp: out/%.axi.raw
	$(LUA) ../misc/raw2bmp.lua out/$*.axi.raw out/$*.axi.bmp out/$*.metadata.lua 1
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*.axi.bmp out/build_$*

out/%.zynq100.bmp: out/%.zynq100.raw
	$(LUA) ../misc/raw2bmp.lua out/$*.zynq100.raw out/$*.zynq100.bmp out/$*.metadata.lua 1
	# keep copy for future reference
	mkdir -p out/build100_$*
	cp out/$*.zynq100.bmp out/build100_$*

out/%.terra.bmp: out/%.terra.raw out/%.metadata.lua
	$(LUA) ../misc/raw2bmp.lua out/$*.terra.raw out/$*.terra.bmp out/$*.metadata.lua 0
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*.terra.bmp out/build_$*

out/%_half.terra.bmp: out/%_half.terra.raw out/%.metadata.lua
	$(LUA) ../misc/raw2bmp.lua out/$*_half.terra.raw out/$*_half.terra.bmp out/$*.metadata.lua 0
	# keep copy for future reference
	mkdir -p out/build_$*
	cp out/$*_half.terra.bmp out/build_$*

out/%.axi.correct.txt : out/%.axi.bmp
	diff out/$*.axi.bmp gold/$*.bmp > out/$*.axi.diff
	test ! -s out/$*.axi.diff && touch $@
	# keep copy for future reference
	mkdir -p out/build_$*
	test ! -s out/$*.axi.diff && touch out/build_$*/$*.axi.correct.txt

out/%.zynq100.correct.txt : out/%.zynq100.bmp
	diff out/$*.zynq100.bmp gold/$*.bmp > out/$*.zynq100.diff
	test ! -s out/$*.zynq100.diff && touch $@
	# keep copy for future reference
	mkdir -p out/build100_$*
	test ! -s out/$*.zynq100.diff && touch out/build100_$*/$*.zynq100.correct.txt

out/%_half.isim.correct.txt : out/%_half.isim.bmp
	diff out/$*_half.isim.bmp gold/$*.bmp > out/$*_half.isim.diff
	test ! -s out/$*_half.isim.diff && touch $@
	# keep copy for future reference
	mkdir -p out/build_$*
	test ! -s out/$*_half.isim.diff && touch out/build_$*/$*_half.isim.correct.txt

out/%.isim.correct.txt : out/%.isim.bmp
	diff out/$*.isim.bmp gold/$*.bmp > out/$*.isim.diff
	test ! -s out/$*.isim.diff && touch $@
	# keep copy for future reference
	mkdir -p out/build_$*
	test ! -s out/$*.isim.diff && touch out/build_$*/$*.isim.correct.txt

out/%.isim.1.correct.txt : out/%.isim.1.bmp
	diff out/$*.isim.1.bmp gold/$*.bmp > out/$*.isim.1.diff
	test ! -s out/$*.isim.1.diff && touch $@
	# keep copy for future reference
	mkdir -p out/build_$*
	test ! -s out/$*.isim.1.diff && touch out/build_$*/$*.isim.1.correct.txt

out/%_half.terra.correct.txt : out/%_half.terra.bmp
	diff out/$*_half.terra.bmp gold/$*.bmp > out/$*_half.terra.diff
	test ! -s out/$*_half.terra.diff && touch $@

out/%.terra.correct.txt : out/%.terra.bmp
	diff out/$*.terra.bmp gold/$*.bmp > out/$*.terra.diff
	test ! -s out/$*.terra.diff && touch $@

out/%.raw.dup : %.raw
	cat $*.raw > $@
	cat $*.raw >> $@

out/%.stats.txt : out/%.axi.bmp
	../misc/stats.sh out/build_$* out/$* $* axi $@

out/%.stats100.txt : out/%.zynq100.bmp
	../misc/stats.sh out/build100_$* out/$* $* axi100 $@

out/%.32nm.txt : out/%.v
	$(eval $@_TOP := $(shell luajit ../misc/extractMetadata.lua out/$*.metadata.lua topModule))
	mkdir -p out/$*_32nm
	cp out/$*.v out/$*_32nm
	cd out/$*_32nm; dc_shell -x 'set TOP $($@_TOP); set FILE $*.v; set OUTFILE ../$*.32nm.txt' -f ../../../platform/32nm/32nm.tcl > OUT.txt
