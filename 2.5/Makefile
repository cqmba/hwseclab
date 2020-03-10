# install icarus verilog 
# install gtkwave

# iverilog -ohello.vvp -tvvp *.v && vvp -lxt2 hello.vvp && gtkwave test.vcd test.gtkw

OUT=test.vvp
SAVEFILE=test.gtkw
DUMPFILE=test.vcd
SRCS=*.v

all: $(OUT)

$(OUT): $(SRCS) 
	iverilog -o $(OUT) -tvvp $(SRCS)

$(DUMPFILE): $(OUT)
	vvp $(OUT)

test: $(DUMPFILE)
	gtkwave --saveonexit $(DUMPFILE) $(SAVEFILE) 

clean:
	rm $(OUT) $(DUMPFILE)

.PHONY: clean test
