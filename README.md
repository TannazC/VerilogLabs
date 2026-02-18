# Verilog FPGA Labs — Digital Systems & FSM Design

**Author:** Tannaz Chowdhury  
**Platform:** DE1-SoC (Cyclone V FPGA)  
**Focus:** Digital logic, synchronous design, counters, and finite state machines  

This repository contains five structured Verilog labs completed on the DE1-SoC FPGA board.  
The progression moves from basic combinational logic to full finite state machine systems with timed hardware control.

The objective of this work is to develop strong RTL intuition — understanding how digital systems behave at the level of clocks, registers, and signal transitions.

---

## Purpose

These labs were completed to:

- Strengthen understanding of synchronous digital systems
- Bridge theory (computer architecture & digital logic) with real hardware
- Develop structured FSM design skills
- Practice arithmetic datapath construction
- Build timing-accurate systems using a 50 MHz clock
- Gain confidence in simulation and FPGA debugging

---

## Lab Breakdown

### Lab 1 — Combinational Logic & Display Systems

Focus: Foundational logic and signal mapping.

Implemented:
- Switch-to-LED wiring
- 2-to-1 multiplexers (single-bit and 4-bit wide)
- 3-to-1 multiplexer (structural composition)
- 7-segment decoder using manually derived Boolean expressions

Key Concepts:
- Truth tables → Boolean equations  
- Sum-of-products logic  
- Vector signals and bit slicing  
- Structural hardware composition  

---

### Lab 2 — Arithmetic & BCD Design

Focus: Structured arithmetic hardware.

Implemented:
- Decimal 7-segment display logic
- Binary-to-decimal conversion
- Ripple-carry adder using full adder modules
- BCD adder with correction logic

Key Concepts:
- Full adder design
- Carry propagation
- Binary-coded decimal arithmetic
- Datapath-style module composition

---

### Lab 3 — Latches & Flip-Flops

Focus: Sequential storage elements and clock behavior.

Implemented:
- Gated RS latch
- Gated D latch
- Master–slave D flip-flop
- Positive and negative edge-triggered flip-flops

Key Concepts:
- Level-sensitive vs edge-triggered storage
- Clock-driven state transitions
- Sequential timing behavior
- Proper reset discipline

---

### Lab 4 — Counters & Timing Systems

Focus: Synchronous counters and clock-enable timing design.

Implemented:
- Structural 8-bit counter (T flip-flop chain)
- Behavioral 16-bit counter (`Q <= Q + 1`)
- 1-second digit flipper (50 MHz driven)
- Ticker-style scrolling display

Key Concepts:
- Wide counters for time scaling
- Clock-enable generation (no derived clocks)
- Modulo-N counting
- Human-visible timing from high-frequency clocks

---

### Lab 5 — Finite State Machines & Control Systems

Focus: FSM architecture and control/datapath separation.

Implemented:
- One-hot encoded sequence detector
- Binary-encoded FSM using case statements
- Morse-code transmitter including:
  - Control FSM
  - Shift register
  - Length counter
  - Half-second timing generator
  - Dot/dash duration control

Key Concepts:
- Moore FSM design
- State encoding strategies
- Controller + datapath separation
- Structured hardware sequencing

---

## Core Design Principles

All designs follow strict synchronous rules:

- Single clock domain (CLOCK_50 when required)
- No internally generated clocks
- Edge-triggered state registers
- Deterministic reset behavior
- Clear separation of combinational and sequential logic
- Modular and reusable components

---

## Simulation & Hardware Verification

Each lab was:

- Simulated using ModelSim
- Verified through waveform analysis
- Implemented on DE1-SoC hardware
- Tested using LEDs and 7-segment displays

This reinforces understanding of:

- Sequential timing behavior
- State transitions across clock edges
- Signal propagation and stability
- Real-world FPGA debugging workflow

---

## Architectural Relevance

These labs strengthen understanding of:

- Registers and state storage
- Control unit design
- Arithmetic datapaths
- Clock-enable timing systems
- Hardware parallelism
- Deterministic execution models

Working at the RTL level clarifies how higher-level software ultimately executes on real silicon.

---

## Summary

This repository documents progression from basic combinational logic to structured, timing-driven finite state systems.

The goal is not simply functional Verilog — but disciplined hardware design grounded in clocked digital architecture.

This work represents a solid foundation for larger FPGA systems, real-time control designs, and advanced hardware projects.
