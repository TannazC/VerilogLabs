# Verilog FPGA Labs — Digital Design & VGA Systems

**Author:** Tannaz Chowdhury  
**Focus:** FPGA-based digital systems, VGA graphics, and hardware-level game foundations  

This repository contains five Verilog labs completed to build a strong foundation in digital logic, FPGA design, and real-time video output. The work emphasizes clean modular hardware design, timing correctness, and a deep understanding of how computer architecture concepts map directly onto physical hardware.

The long-term objective of this work is to confidently design and run interactive systems and simple games on an FPGA using VGA output, structured finite state machines, and hardware-controlled datapaths.

---

## Purpose

These labs were completed to:

- Strengthen understanding of synchronous digital systems
- Bridge computer architecture theory with hardware implementation
- Prepare for VGA-based graphics systems and FPGA game engines
- Develop confidence with RTL design, simulation, and hardware debugging
- Reinforce timing discipline and modular design patterns

---

## Core Concepts Reinforced

### 1. Synchronous Digital Design

All systems were built using clocked logic and proper reset behavior.

Key takeaways:
- Difference between combinational and sequential logic
- Importance of edge-triggered registers
- Setup and hold timing awareness
- Avoiding unintended latches
- Designing predictable state transitions

This reinforces how processors and memory elements operate at the hardware level.

---

### 2. Finite State Machines (FSMs)

Multiple labs required structured control logic using Moore and Mealy FSM patterns.

Key takeaways:
- State encoding strategies
- Clean separation of control and datapath
- Deterministic state transitions
- Reset-state reliability
- Designing scalable state machines

FSM design directly connects to control units inside CPUs and GPU pipelines.

---

### 3. Datapath Design

Arithmetic, counters, and register-based logic were implemented structurally.

Key takeaways:
- Register-transfer level (RTL) thinking
- Building arithmetic using hardware operators
- Designing counters and timing controllers
- Resource-conscious hardware design

Understanding datapaths strengthens comprehension of ALUs and pipeline stages in computer architecture.

---

### 4. VGA Signal Generation

A major milestone in preparation for FPGA-based games is generating valid VGA signals.

Concepts applied:
- Horizontal and vertical sync timing
- Pixel coordinate counters
- Frame timing and refresh rates
- Resolution constraints
- Color channel output control

Key takeaway:
Video output is entirely timing-driven. Every pixel depends on strict clock-cycle precision. This builds appreciation for how GPUs generate frames at the hardware level.

---

### 5. Modular Hardware Design

All designs were written with clear module separation and hierarchical structure.

Principles followed:
- Single-responsibility modules
- Clean input/output interfaces
- Parameterized design where appropriate
- Reusable components
- Clear signal naming

This mirrors scalable hardware system design and prepares for larger FPGA projects like game engines.

---

### 6. Simulation and Verification

Each design was tested through simulation before hardware deployment.

Key takeaways:
- Writing effective testbenches
- Understanding waveform timing
- Debugging race conditions
- Validating reset behavior
- Observing signal propagation over time

Simulation builds the same debugging discipline required in processor and embedded system design.

---

### 7. Hardware Debugging

FPGA testing reinforced:

- Clock domain awareness
- Switch and button debouncing considerations
- Observing behavior through LEDs and displays
- Incremental testing methodology

Hardware debugging develops intuition beyond what software-only testing can provide.

---

## Architectural Connections

These labs directly strengthen understanding of:

- Register files
- Control units
- Timing pipelines
- Memory-mapped I/O
- Hardware parallelism
- Deterministic execution models

Working at the RTL level clarifies how higher-level software ultimately executes on real silicon.

---

## Preparation for FPGA Game Systems

These labs lay the groundwork for:

- VGA-based sprite engines
- Collision detection hardware
- Frame-based animation
- Score counters and state logic
- Real-time input handling
- Structured game loops implemented in hardware

Building graphics systems at the hardware level deepens understanding of performance constraints and parallel processing.

---

## Personal Development Goals Reinforced

- Thinking in hardware, not software
- Designing with timing in mind
- Structuring clean Verilog modules
- Debugging systematically
- Translating theory into working systems

---

## Summary

These five labs represent a foundational step toward advanced FPGA systems and hardware-based game design. They reinforce computer architecture principles while developing real hardware intuition.

The goal is not just to write Verilog that works, but to understand why it works — at the level of clocks, registers, and signals.

This repository documents that progression.
