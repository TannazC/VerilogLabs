# Verilog / SystemVerilog Learning Repo

A structured collection of synthesizable RTL modules, testbenches, and notes for learning digital logic design with Verilog/SystemVerilog.

## Repository map
- `src/` — synthesizable modules grouped by topic
  - `combinational/` — mux/decoder/adder/ALU-style logic
  - `sequential/` — flops, registers, counters, shift registers
  - `fsm/` — FSM templates + examples
  - `datapath/` — datapath/control patterns (register files, simple pipelines)
  - `top/` — integration/top-level wrappers
- `tb/` — testbenches mirroring `src/` layout
- `docs/` — short notes + concept explanations
- `sim/` — simulation scripts (iverilog/modelsim)
- `waves/` — waveform outputs (kept out of git except placeholder)

## Quick start (simulation)
Install Intel Quartus + ModelSim + DESim (if you don't have access to hardware)

## Recommended learning path (folders to follow)
1. **Combinational**
   - mux, decoder, adder, small ALU blocks
2. **Sequential**
   - DFF → register → counter → shift register
3. **FSM**
   - FSM template → example controllers (traffic light, sequence detector, etc.)
4. **Datapath + control**
   - register file → simple datapath + control FSM


