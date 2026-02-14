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
### Option A: Icarus Verilog (simple)
1. Install `iverilog` and `vvp`
2. Run:
   - `bash sim/iverilog/run.sh`

### Option B: ModelSim / Questa
- Open ModelSim and run `sim/modelsim/run.do`

> Tip: Start with modules in `src/combinational/` + their matching testbenches in `tb/combinational/`.

## Recommended learning path (folders to follow)
1. **Combinational**
   - mux, decoder, adder, small ALU blocks
2. **Sequential**
   - DFF → register → counter → shift register
3. **FSM**
   - FSM template → example controllers (traffic light, sequence detector, etc.)
4. **Datapath + control**
   - register file → simple datapath + control FSM

## RTL style rules used here
- Use `always_ff @(posedge clk)` for flops and `always_comb` for combinational logic (SystemVerilog).
- Non-blocking assignments (`<=`) in sequential logic.
- Blocking assignments (`=`) inside `always_comb`.
- Prefer explicit reset behavior.
- Keep interfaces simple and document assumptions.

See `docs/references/style-guide.md` for details.

## Adding a new module (checklist)
- Create the module in the right `src/<topic>/` folder.
- Create a matching testbench in `tb/<topic>/tb_<module>.sv`.
- Add at least:
  - a few directed tests
  - one randomized/sweep test (if reasonable)
  - waveform dump (optional but useful)
- Document purpose + ports in a short header comment.

## Notes and references
- `docs/concepts/` contains short explanations (timing, FSMs, testbenches, etc.)
- `docs/references/cheat-sheet.md` contains quick syntax reminders and common patterns

## License
Choose a license that matches goals (MIT is common for personal learning repos).
