#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "colors.typ": *

// ==========================================
// METADATA & GLOBALS
// ==========================================
// I thought it would be usefull in writing (shortcuts), in retrospect I can say man am I bad that figuring that out
#let poster-title = [Adapting F' FreeRTOS for Space-Grade STM32 Embedded Systems: EnduroSat OBCI]
#let poster-authors = [Viren Kumar, [Tirth S. Thakkar], [Howard S. Lee]]
#let poster-affiliations = [CubeStep-Cerberus, California State Polytechnic University, Pomona]
#let poster-advisors = [Advisors: Navid Nakhjiri, Marco Maggia]

// ==========================================
// 1. ABSTRACT & INTRODUCTION
// ==========================================
#let abstract-intro = [
  Small satellite missions increasingly depend on software-defined behavior to coordinate subsystem health, command handling, telemetry, fault response, and mission operations. For CubeSTEP-Cerberus, the flight software targets deployment on the EnduroSat On-Board Computer Type I, based on the STM32H753 microcontroller, while supporting a thermal experiment payload under strict power, communications, memory, and timing constraints.

  NASA JPL's F Prime framework provides a reusable, component-based architecture for flight software development. However, many F Prime deployments assume a Linux or POSIX-like execution environment. This project adapts F Prime for FreeRTOS-based STM32 embedded platforms, with emphasis on the EnduroSat OBCI flight computer using the STM32H753 microcontroller.

  The work demonstrates that F Prime can be extended to previously unsupported bare-metal and RTOS-based targets through FreeRTOS Operating System Abstraction Layer (OSAL) modifications, removal of POSIX assumptions, board-specific initialization, custom toolchain support, and deployment-oriented validation on STM32 hardware.
]

#let abstract-smcit = [
 Small satellite teams often develop flight software and mission operations separately, leading to software behaviors that drift out of sync with ground procedures. To fix this, we present a co-design approach that directly links mission goals and operational procedures to the onboard flight software architecture. Demonstrated on the CubeSTEP-Cerberus mission using NASA’s F′ framework and FreeRTOS, our system maps mission intent into five constrained software states (Initialization, Safe, Idle, Experiment, and Transmit) guarded by automated health checks. This co-design strategy ensures the spacecraft acts autonomously to preserve its goals while strictly maintaining operator control over critical decisions.

]
// ==========================================
// 2. PROBLEM & CONTRIBUTION
// ==========================================
// Obvciouslly clanker made that I initally used for intro (then I wrote my own with this as reference)
#let problem-contribution = [
  *Problem:* Student-led CubeSat missions often develop mission operations, subsystem procedures, and flight software in parallel but not always in direct alignment. This can create gaps between what operators intend, what procedures describe, and what onboard software is allowed to do autonomously.

  *Technical Challenge:* F Prime provides strong architectural structure, but deployment on an embedded STM32 FreeRTOS target requires changes below the application layer. The software must preserve F Prime component semantics while replacing host-oriented assumptions with deterministic embedded behavior.

  *Core Contributions:*
  - Adapted the F Prime FreeRTOS OSAL for STM32-class targets.
  - Developed separate FreeRTOS deployment paths for a development board and the EnduroSat OBCI.
  - Replaced or isolated POSIX-dependent framework behavior.
  - Created board-specific initialization, memory, linker, and toolchain support.
  - Validated F Prime topology startup, scheduler execution, and GDS communication on embedded hardware.
]

// ==========================================
// 3. SYSTEM ARCHITECTURE
// ==========================================
//Pretty pricture (May need to sync up with other guy (canvas sucks compared to fletcher)*I beleive in flether supremicy)
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/wrap-it:0.1.1": wrap-content

#let architecture-diagram = box(
  // Space between the prose and the diagram.
  inset: (
    left: 1.5em,
    bottom: 0.8em,
  ),

  canvas(length: 0.7cm, {
    import draw: *

    let w = 18
    let h = 2.4
    let gap = 1.4

    let draw-layer(y, name, label, fill-col) = {
      rect(
        (0, y),
        (w, y + h),
        name: name,
        fill: fill-col,
        stroke: black + 1pt,
        radius: 0.12,
      )

      content(
        name,
        text(
          weight: "bold",
          size: 24pt,
          label,
        ),
      )
    }

    draw-layer(
      h + gap,
      "bsp",
      "Test Case",
      color.luma(218),
    )

    draw-layer(
      2 * (h + gap),
      "hal",
      "Command/Telemetry Product",
      color.luma(205),
    )

    draw-layer(
      3 * (h + gap),
      "rtos",
      "FSW State/Guard",
      color.rgb("#d4e1f9"),
    )

    draw-layer(
      4 * (h + gap),
      "osal",
      "Flight Rule",
      color.rgb("#f9d4d4"),
    )

    draw-layer(
      5 * (h + gap),
      "fw",
      "CONOPS Phase",
      color.luma(225),
    )

    draw-layer(
      6 * (h + gap),
      "app",
      "Mission Objective",
      color.rgb("#f9ebd4"),
    )

    for i in range(1, 6) {
      let y1 = i * (h + gap) + h
      let y2 = (i + 1) * (h + gap)

      line(
        (w / 2, y1),
        (w / 2, y2),
        stroke: black + 4pt,
        mark: (start: "stealth"),
      )
    }
  }),
)

#let system-architecture = [
  #wrap-content(
    architecture-diagram,
    align: top + right,
    column-gutter: 0pt,
  )[
     *Initialization state* is entered after deploying from the launcher. Detumbling executes until reaching stable body rates, followed by the deployment of the antenna and solar panels. The spacecraft then sends its first beacon for ground station connection. During this state, early subsystem setup takes place. 

  
             * Safe state* is entered whenever the spacecraft is undergoing degraded health. The spacecraft operates with minimum required functionality regarding power, communication, and recoverability. Once the spacecraft returns to acceptable conditions, a transition is made into idle. Commands can still be queued, but execution is deferred until transitioning into the appropriate state. 

              *Idle state* is the nominal state, performing health checks, peripheral polling, memory scrubbing, and ground-contact monitoring. Experiment commands can be queued, but execution is delayed until guards for the experiment state are satisfied.  

              *Experiment state* is entered upon satisfying requirements for mission phase, resource state, payload readiness, and data-storage. This state contains setup, execution, and closeout substates. Once operator inputs for OHP variant, sunlight phase, and heater power level are verified, and once the temperature, power margin, attitude stability, and storage availability meet requirements, a transition to execution is made for thermal data collection. At closeout, data is stored and a transition to idle is made.
              === Transmit state
              A transition to transmit state is made from idle once ground-station contact is made to downlink mission data and receive commands. Lost contact causes a transition to idle. 
  ]
]

#let current_progress = [
 /* The current development progress has validated a no-boot proof-of-concept implementation of F Prime FreeRTOS on the EnduroSat OBCI through the creation of a register level UART driver and validating an F Prime GDS connection via F Prime framing sequence. Additionally, the issues in upstream the F Prime OSAL FreeRTOS implementation regarding memory allocation, were resolved and issues in F Prime resolved for non-posix platforms. Future work consists of boot-loader and concrete driver integration for flight ready software deployment. 
*/
#table(
  columns: (0.5fr, 1.6fr,),
  inset: 18pt,
  align: left,
  stroke: none,
  [*EnduroSatOBC*],[validated no-boot Fprime/FreeRTOS proof of concept on the OBC ],

  [*GDS Connectivity*],[Implimented a register-level UART driver and confirmed F' GDS communication through the F' framing stack.],

  [*Additional Issues*],[Resolved memory allocation issues in upstream F Prime OSAL FreeRTOS implementation],
)
Current progress has validated the practicality of using F Prime on the endurostat OBCI. We are now able to evaluate system viability with next steps focusing on refining implementation and software component integration 
]

// ==========================================
// 4. F Prime + FREERTOS IMPLEMENTATION MAP
// ==========================================
//Read the documentation for understanding might not be good shit
#let s = 2
#let implementation-map = [
  F Prime components are mapped onto FreeRTOS execution primitives while preserving command, telemetry, event, and scheduling behavior.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#align(center)[
  #diagram(
    node-defocus: 0,
    spacing: (2cm, 2cm), // X and Y spacing between nodes
    edge-stroke: 1.2pt,
    node-corner-radius: 4pt,
    node-stroke: black + 0.8pt,

    // Helper function to keep our nodes uniform
    let block(pos, name, label, fill-col) = {
      node(
        pos, 
        align(center)[#text(size: 18pt, weight: "bold", label)], 
        name: name, 
        fill: fill-col, 
        width: 4.8cm*s, 
        height: 1.2cm*s
      )
    },

    // --- ROW 1 (Top) ---
    block((0, 0), <gds>,   "F Prime GDS\nGround Commands", rgb("e8e8ff")),
    block((1, 0), <cmd>,   "Command Dispatcher\nValidation + Routing", rgb("fff0cc")),
    block((2, 0), <state>, "Mission State Manager\nAuthority Guards", rgb("ffe0e0")),

    // --- ROW 2 (Middle) ---
    block((0, 1), <tlm>,   "Telemetry Channels\nHealth + Payload Data", rgb("e0ffe0")),
    block((1, 1), <sched>, "Rate Groups\nFreeRTOS Tasks", rgb("ddeeff")),
    block((2, 1), <fault>, "Fault Manager\nEvents + Safe Mode", rgb("ffd6d6")),

    // --- ROW 3 (Bottom) ---
    // Offset by 0.5 to center them perfectly under the gaps
    block((1, 2), <subsys>, "Subsystem Interfaces\nEPS / ADCS / COMMS / Payload", rgb("eeeeee")),
    block((2, 2), <osal>,   "F Prime FreeRTOS OSAL\nQueues / Mutexes / Time", rgb("f9d4d4")),

    // --- EDGES ---
    edge(<gds>, <cmd>, "-|>"),
    edge(<cmd>, <state>, "-|>"),
    edge(<state>, <fault>, "-|>"),
    edge(<fault>, <sched>, "-|>"),
    edge(<sched>, <tlm>, "-|>"),

    // Use a slight bend to separate bidirectional arrows perfectly
    edge(<sched>, <subsys>, "-|>", bend: 0deg),
    edge(<subsys>, <sched>, "-|>", bend: 0deg),

    edge(<osal>, <subsys>, "-|>")
  )
]

  #align(center)[*Figure 2:* Command, Telemetry, Scheduling, and Fault Flow]

  Command handling is routed through F Prime command dispatchers and checked against mission-state authority rules before reaching subsystem components. Telemetry and events flow back through F Prime channels for downlink through the Ground Data System. Periodic behavior is driven by F Prime rate groups backed by FreeRTOS tasks, queues, and synchronization primitives.
]

// ==========================================
// 5. OSAL ADAPTATION & EMBEDDED CHALLENGES
// ==========================================
//good shit
#let osal-adaptation = [
  Porting F Prime to STM32 FreeRTOS is primarily a deployment and hardware integration problem. The OSAL must translate F Prime execution assumptions into deterministic FreeRTOS primitives while respecting STM32 memory, stack, and interrupt constraints.
  /*


 ''' *Task Management:* F Prime active components require predictable task creation, priority assignment, and stack allocation. Stack sizes and priorities were adjusted for embedded runtime behavior rather than desktop execution assumptions.

  *Memory Management:* The deployment aligns F Prime allocation patterns with the STM32H753 memory map, FreeRTOS heap configuration, startup files, and linker script. Host-style dynamic loading and filesystem assumptions are avoided.

  *Synchronization and Queues:* FreeRTOS mutexes, semaphores, and queues are used to preserve component execution semantics and protect shared framework resources.

  *Non-POSIX Operation:* Filesystem access, standard I/O, process behavior, and host-level timing assumptions are isolated or removed where they conflict with a 32-bit microcontroller environment.

  *Board Bring-Up:* The EnduroSat OBCI requires explicit initialization of clock configuration, memory regions, serial interfaces, peripheral buses, and interrupt behavior before F Prime topology startup.

  Porting F Prime (F') to STM32/FreeRTOS required translating framework-level execution assumptions into deterministic embedded primitives while preserving command, telemetry, scheduling, and fault behavior.
*/
  #table(
    columns: (0.7fr, 1.8fr),
    inset: 12pt,
    align: left,
    stroke: none,
    
    [*Task execution*],
    [F' active components are mapped to FreeRTOS tasks with explicit priorities and stack sizes.],

    [*Memory control*],
    [Allocation is aligned with the STM32H753 memory map, FreeRTOS heap configuration, startup files, and linker script.],

    [*Synchronization*],
    [FreeRTOS queues, mutexes, and semaphores preserve component execution semantics and protect shared resources.],

    [*Non-POSIX operation*],
    [Filesystem, process, standard I/O, and host-timing assumptions are isolated or removed for the 32-bit microcontroller target.],

    [*Board bring-up*],
    [Clock, GPIO, UART, I2C, SPI, memory-region, and interrupt initialization occur before F' topology startup on the EnduroSat OBCI.]
  )
]


// ==========================================
// 6. MISSION SOFTWARE STATES
// ==========================================
// Based on Markov chain stuff
#let software-state = [
  CubeSTEP software behavior is organized around a constrained state machine. Each state defines permitted commands, telemetry expectations, subsystem authority, and allowed transitions.


  #align(center)[
    #figure(
      diagram(
        node-defocus: 1,
        spacing: (6cm, 3cm),
        edge-stroke: 3pt,
        node-outset: 9pt,

        node((0, 0), [*Start*],       name: <init>, radius: 2cm, stroke: 2pt, fill: rgb("e0e0e0")),
        node((1, 0), [*Safe*],       name: <safe>, radius: 2cm, stroke: 2pt, fill: rgb("ffcccc")),
        node((3, 0), [*Idle*],       name: <idle>, radius: 2cm, stroke: 2pt, fill: rgb("ccffcc")),
        node((4, 0), [*Transmit*],   name: <tx>,   radius: 2cm, stroke: 2pt, fill: rgb("ffffcc")),
        node((2, 0), [*Experiment*], name: <exp>,  radius: 2.5cm, stroke: 2pt, fill: rgb("ccccff")),

        {
          let transition(a, b, label, paint: black, bend: 45deg, side: left) = {
            edge(a, b, label, "-|>", stroke: paint, bend: bend, label-side: side, label-pos: 0.5)
          }

          transition(<init>, <safe>, [Boot Complete])
          transition(<idle>, <tx>, [Comm Window], bend: 15deg)
          transition(<idle>, <exp>, [Auth.], bend: -35deg)
          transition(<tx>, <idle>, [Downlink ], bend: 15deg)
          transition(<exp>, <idle>, [Test Complete], bend: -15deg)
          transition(<safe>, <idle>, [Resume], bend: 35deg)

          transition(<idle>, <safe>, [Fault], paint: red)
          transition(<tx>, <safe>, [Fault], paint: red, bend: -45deg)
          transition(<exp>, <safe>, [Fault], paint: red, bend: 16deg)

        }
        
      ),
    )
  ]

  Transitions evaluate spacecraft health, power margin, thermal limits, communications availability, payload readiness, and mission phase. Commands that violate a state's authority boundary are rejected and produce an explanatory event for ground operators.
]





// =============================================================================
// MISSION SOFTWARE STATES SECTION
// =============================================================================

#let software-states = [
  CubeSTEP software behavior is organized around a constrained state machine.
  Each state defines permitted commands, telemetry expectations, subsystem
  authority, and allowed transitions.

  #v(1em)

  #grid(
    columns: (auto, 1fr),
    gutter: 1.5em,
    align: right + horizon,

    // -------------------------------------------------------------------------
    // LEFT: Spacecraft state machine
    // -------------------------------------------------------------------------
    [
        #align(right)[
    #figure(
      diagram(
        node-defocus: 1,
        spacing: (7cm, 3cm),
        edge-stroke: 3pt,
        node-outset: 9pt,

        node((2, 0), [*Start*],       name: <init>, radius: 2cm, stroke: 2pt, fill: rgb("e0e0e0")),
        node((3, 0), [*Safe*],       name: <safe>, radius: 2cm, stroke: 2pt, fill: rgb("ffcccc")),
        node((4, 0), [*Experiment*], name: <exp>,  radius: 2.5cm, stroke: 2pt, fill: rgb("ccccff")),
        node((5, 0), [*Idle*],       name: <idle>, radius: 2cm, stroke: 2pt, fill: rgb("ccffcc")),
        node((6, 0), [*Transmit*],   name: <tx>,   radius: 2cm, stroke: 2pt, fill: rgb("ffffcc")),

        {
          let transition(a, b, label, paint: black, bend: 45deg, side: left) = {
            edge(a, b, label, "-|>", stroke: paint, bend: bend, label-side: side, label-pos: 0.5)
          }

          transition(<init>, <safe>, [Boot Complete])
          transition(<idle>, <tx>, [Comm Window], bend: 15deg)
          transition(<idle>, <exp>, [Auth.], bend: -35deg)
          transition(<tx>, <idle>, [Downlink ], bend: 15deg)
          transition(<exp>, <idle>, [Test Complete], bend: -15deg)
          transition(<safe>, <idle>, [Resume], bend: 35deg)

          transition(<idle>, <safe>, [Fault], paint: red)
          transition(<tx>, <safe>, [Fault], paint: red, bend: -45deg)
          transition(<exp>, <safe>, [Fault], paint: red, bend: 16deg)

        }
        
      ),
    )
  ]

    ],

    // -------------------------------------------------------------------------
    // RIGHT: Experiment-state behavior
    // -------------------------------------------------------------------------
    column-gutter: 7em,
    [
      #align(left)[
        #canvas(
          length: 1cm,
          {
            let block(x, y, width, height, label, fill-color) = {
              draw.rect(
                (x, y),
                (x + width, y - height),
                fill: fill-color,
                stroke: black + 1.3pt,
                radius: 4pt,
              )

              draw.content(
                (x + width / 2, y - height / 2),
                align(center + horizon)[
                  #text(
                    size: 20pt,
                    weight: "bold",
                    label,
                  )
                ],
              )
            }

            // Main experiment flow
            block(
              0,
              0,
              8,
              2.5,
              "Experiment Set-Up",
              rgb("e8e8ff"),
            )

            block(
              0,
              -4,
              8,
              2.5,
              "Perform Experiment",
              rgb("eaeaea"),
            )

            block(
              0,
              -8,
              8,
              2.5,
              "Experiment End",
              rgb("ffe0e0"),
            )

            // Shared state blocks
            block(
              10,
              0,
              4,
              10.5,
              "Safety State",
              rgb("fff2cc"),
            )

            block(
              0,
              -12,
              14,
              2.5,
              "Idle State",
              rgb("e0ffe0"),
            )

            // Main vertical flow
            draw.line(
              (4, -2.5),
              (4, -4),
              mark: (end: ">"),
            )

            draw.line(
              (4, -6.5),
              (4, -8),
              mark: (end: ">"),
            )

            draw.line(
              (4, -10.5),
              (4, -12),
              mark: (end: ">"),
            )

            // Fault paths into Safety State
            draw.line(
              (8, -1.25),
              (10, -1.25),
              mark: (end: ">"),
            )

            draw.line(
              (8, -5.25),
              (10, -5.25),
              mark: (end: ">"),
            )

            draw.line(
              (8, -9.25),
              (10, -9.25),
              mark: (end: ">"),
            )

            // Idle-to-Safety transition
            draw.line(
              (12, -12),
              (12, -10.5),
              mark: (end: ">"),
            )
          },
        )
      ]
    ],
  )

  #v(1em)

  Transitions evaluate spacecraft health, power margin, thermal limits,
  communications availability, payload readiness, and mission phase.
  Commands that violate a state's authority boundary are rejected and produce
  an explanatory event for ground operators.
  
]

// ==========================================
// 7. MISSION AUTHORITY BOUNDARIES
// ==========================================
#let authority-boundaries = [ //Might use this for presentation so not deleting, realized was redundant after I figured out how to make diagram
 Concept of Operations are focused on Survivability, Communication, Data Collection, and Experiment Execution in that order.
#figure(
  table(
    columns: (0.34fr, 0.66fr),
    align: (left + top, left + top),
    inset: (x: 6pt, y: 5pt),
    stroke: none,

    table.hline(stroke: 1pt),

    table.header(
      [*Mission constraint*],
      [*Software rule or guard*],
    ),

    table.hline(stroke: 0.6pt),

    [Orbital phase affects experiment validity],
    [Experiment entry requires the requested sunlight condition or approved override.],

    [Intermittent communication],
    [Spacecraft must maintain health, beacon status, and queue data without ground contact.],

    [Limited power margin],
    [Heater activity and high-rate downlink are inhibited below EPS thresholds.],

    [Limited storage and downlink],
    [Experiment data cannot overwrite undownlinked data without an approved rule.],

    [Commissioning before science],
    [Payload execution is locked out until required bus and sensor checks pass.],

    [Decommissioning is irreversible],
    [Final payload disablement and data closeout require ground authorization.],

    table.hline(stroke: 1pt),
  ),
) <tab:constraint-rules>
 

  This structure preserves execution intention while being actionable. Integrating these rules into general systems allows us to create an behavioral logic framework that can robustly transition into software
]

// ==========================================
// 8. VALIDATION & RESULTS
// ==========================================
#let results = [ //Goddamm hot clanker garbage when I asked for reccomendations based on paper (useless trash I only keep here as a mark of shame)
  Verification focused on deployment-oriented milestones rather than only source-level compilation.

  #table(
    columns: (1.3fr, 2.1fr, 2fr),
    inset: 5pt,
    align: left,
    [*Validation Area*], [*Method*], [*Observed Result*],

    [Build Verification],
    [Compile F Prime deployment with custom STM32 toolchain, HAL, FreeRTOS configuration, and linker scripts.],
    [Target image builds without host-only dependencies.],

    [Runtime Bring-Up],
    [Flash deployment to STM32 hardware and verify startup sequence.],
    [Hardware initializes, F Prime topology starts, FreeRTOS scheduler runs.],

    [OSAL Behavior],
    [Exercise task creation, queues, mutexes, timing, and component execution.],
    [Framework services operate through FreeRTOS primitives.],

    [GDS Connectivity],
    [Connect embedded target to F Prime Ground Data System through the framing stack.],
    [Valid output is received by the GDS.],

    [Mission Logic],
    [Evaluate state transitions, command rejection, and fault-path behavior.],
    [State authority boundaries are enforced.]
  )

  These results demonstrate a practical deployment path for using F Prime FreeRTOS on space-caliber STM32 hardware and establish the foundation for CubeSTEP mission software integration.
]

// ==========================================
// 9. FUTURE WORK / FLIGHT READINESS
// ==========================================
#let future-work = [ //Semi Filler
  Next steps focus on converting the deployment from a successful bring-up into a flight-ready software baseline.

  - Expand subsystem interface components for EPS, ADCS, communications, payload heaters, thermocouples, and nonvolatile storage.
  - Complete software-in-the-loop and hardware-in-the-loop tests for nominal operations and representative fault cases.
  - Add long-duration runtime testing to characterize stack usage, heap stability, timing jitter, queue behavior, and telemetry throughput.
  - Formalize mission-stage constraints as testable requirements tied to command authorization and transition guards.
  - Integrate experiment scheduling with communications-window planning and onboard data-volume limits.
]

// ==========================================
// 10. CONCLUSION
// ==========================================
#let conclusion = [ //Dont need this is not a presentation
  This work extends F Prime FreeRTOS from a general embedded framework path to a practical STM32 deployment suitable for CubeSat-class flight hardware. By adapting the OSAL, isolating POSIX assumptions, defining board-specific initialization, and validating runtime behavior on STM32 hardware, the project provides a reusable model for student-led spacecraft teams seeking structured flight software on constrained embedded targets.

  For CubeStep-Cerberus, the result is more than a successful port: it is a mission-aware software architecture that connects onboard behavior to operational authority, subsystem constraints, and future verification workflows.
]

#let ExperimentalSubModule = [
#let block(x, y, w, h, label, fill) = {
  draw.rect(
    (x, y),
    (x + w, y - h),
    fill: fill,
    stroke: black + 0.8pt,
    radius: 4pt,
  )
  draw.content(
    (x + w / 2, y - h / 2),
    align(center + horizon)[#text(size: 18pt, weight: "bold", label)],
  )
}

#align(center)[
  #canvas({
    // Main column
    block(0, 0, 8, 2.5, "Experiment Set-Up", rgb("e8e8ff"))
    block(0, -4, 8, 2.5, "Perform Experiment", rgb("EAEAEA"))
    block(0, -8, 8, 2.5, "Experiment End", rgb("ffe0e0"))

    // Spanning blocks
    block(10, 0, 4, 10.5, "Safety State", rgb("FFF2CC"))
    block(0, -12, 14, 2.5, "Idle State", rgb("e0ffe0"))

// Vertical arrows
draw.line((4, -2.5), (4, -4), mark: (end: ">"))
draw.line((4, -6.5), (4, -8), mark: (end: ">"))

// Safety arrows - all horizontal
draw.line((8, -1.25), (10, -1.25), mark: (end: ">"))
draw.line((8, -5.25), (10, -5.25), mark: (end: ">"))
draw.line((8, -9.25), (10, -9.25), mark: (end: ">"))

// Experiment End to Idle State - vertical
draw.line((4, -10.5), (4, -12), mark: (end: ">"))

// Idle State to Safety State - vertical
draw.line((12, -12), (12, -10.5), mark: (end: ">"))
  })
]
]
#let system-architectures = [

  #align(center)[
    #canvas(length: 1.6cm, {
      import draw: *

      let w = 13
      let h = 1
      let gap = .8

      let draw-layer(y, name, label, fill-col) = {
        rect((0, y), (w, y + h), name: name, fill: fill-col, stroke: black + 1pt, radius: 0.12)
        content(name, text(weight: "bold", size: 24pt, label))
      }

      draw-layer(0, "hw", "EnduroSat OBCI Hardware: STM32H753", luma(232))
      draw-layer(h + gap, "bsp", "Clock, GPIO, UART, I2C, SPI, Memory", luma(218))
      draw-layer(2*(h + gap), "hal", "Generic STM32 HAL + Startup Code", luma(205))
      draw-layer(3*(h + gap), "rtos", "Hardware-Compliant FreeRTOS Kernel", rgb("d4e1f9"))
      draw-layer(4*(h + gap), "osal", "Adapted F Prime FreeRTOS OSAL", rgb("f9d4d4"))
      draw-layer(5*(h + gap), "fw", "Cmd, Tlm, Events, Time, Ports", rgb("d4f9d4"))
      draw-layer(6*(h + gap), "app", "Mission Components and State Logic", rgb("f9ebd4"))

      for i in range(0, 6) {
        let y1 = i*(h + gap) + h
        let y2 = (i + 1)*(h + gap)
        line((w/2, y1), (w/2, y2), stroke: black + 4pt, mark: (start: "stealth"))
      }
    })
  ]

]
#let traceability-figure = [
    #align(center)[
    #canvas(length: .7cm, {
      import draw: *

      let w = 18
      let h = 2.4
      let gap = 1.4

      let draw-layer(y, name, label, fill-col) = {
        rect((0, y), (w, y + h), name: name, fill: fill-col, stroke: black + 1pt, radius: 0.12)
        content(name, text(weight: "bold", size: 24pt, label))
      }

      draw-layer(h + gap, "bsp", "Test Case", color.luma(218))
      draw-layer(2 * (h + gap), "hal", "Command/Telemetry Product", color.luma(205))
      draw-layer(3 * (h + gap), "rtos", "FSW State/Guard", color.rgb("#d4e1f9"))
      draw-layer(4 * (h + gap), "osal", "Flight Rule", color.rgb("#f9d4d4"))
      draw-layer(5 * (h + gap), "fw", "CONOPS Phase", color.rgb("#d4f9d4"))
      draw-layer(6 * (h + gap), "app", "Mission Objective", color.rgb("#f9ebd4"))

      for i in range(1, 6) {
        let y1 = i*(h + gap) + h
        let y2 = (i + 1)*(h + gap)
        line((w/2, y1), (w/2, y2), stroke: black + 4pt, mark: (start: "stealth"))
      }
    })
  ]
]

// ==========================================
// ACKNOWLEDGMENTS
// ==========================================
#let acknowledgements = [ //Would be nice but is filler
  We thank the CubeStep-Cerberus team, the Flight Software and Mission Design and Operations subteams, and our advisors Navid Nakhjiri for their technical guidance and project support. We also acknowledge NASA JPL's F Prime project and the open-source contributors whose work enabled this embedded flight software development effort.
  #v(-1em)
]

// ==========================================
// REFERENCES
// ==========================================
// For the poster version, keep references in the bibliography file,
// but do not show inline viewer-facing citation tags inside the text.
#let references = [
  #bibliography("references.bib", title: [], full: true)
]

#let SwModulesDiagram = [

  
#import "@preview/cetz:0.5.2": canvas, draw

#let block(x, y, w, h, label, fill) = {
  draw.rect(
    (x, y),
    (x + w, y - h),
    fill: fill,
    stroke: black + 0.8pt,
    radius: 4pt,
  )

  draw.content(
    (x + w / 2, y - h / 2),
    align(center + horizon)[
      #text(
        weight: "semibold",
        size: 20pt,
      )[
        #label
      ]
    ],
  )
}

#align(center)[
  #canvas({
    // Available category colors
    let blue-fill = rgb("dce7f8")
    let red-fill = rgb("f6d1d2")
    let purp-fill = rgb("e3d5eb")
    let yellow-fill = rgb("fff2cc")
    let orange-fill = rgb("fce5cd")
    let grey-fill = rgb("eeeeee")

    let x = 7
    let y = 2

    let colspace = x + 0.5
    let rowspace = y + 1

    let col1 = 1
    let col2 = col1 + colspace
    let col3 = col2 + colspace
    let col4 = col3 + colspace

    let row1 = -2
    let row2 = row1 - rowspace
    let row3 = row2 - rowspace
    let row4 = row3 - rowspace
    let row5 = row4 - rowspace
    let row6 = row5 - rowspace
    let row7 = row6 - rowspace

    // Main bounding container
    draw.rect(
      (0, -1),
      (32, -22.5),
      fill: none,
      stroke: black + 3pt,
      radius: 36pt,
    )

    // -------------------------------------------------------------------------
    // F PRIME COMMON
    // -------------------------------------------------------------------------
    block(col1, row1, x, y, "ActiveLogger", blue-fill)
    block(col2, row1, x, y, "CmdDispatcher", blue-fill)
    block(col3, row1, x, y, "CmdSequencer", blue-fill)
    block(col4, row1, x, y, "FileDownLink", blue-fill)

    block(col1, row2, x, y, "FileUpLink", blue-fill)
    block(col2, row2, x, y, "FrameAccumulator", blue-fill)
    block(col3, row2, x, y, "TlmChan", blue-fill)

    // -------------------------------------------------------------------------
    // F PRIME FREERTOS
    // -------------------------------------------------------------------------
    block(col4, row2, x, y, "OSAL", red-fill)

    // -------------------------------------------------------------------------
    // F PRIME STM32H7XXX
    // -------------------------------------------------------------------------
    block(col1, row3, x, y, "I2C Driver", purp-fill)
    block(col2, row3, x, y, "SPI Driver", purp-fill)
    block(col3, row3, x, y, "UART Driver", purp-fill)

    // -------------------------------------------------------------------------
    // OPEN SOURCE
    // -------------------------------------------------------------------------
    block(col4, row3, x, y, "FreeRTOS Kernel", yellow-fill)
    block(col1, row4, x, y, "USUFramingStructure", yellow-fill)
    block(col2, row4, x, y, "USU Transceiver II", yellow-fill)

    // -------------------------------------------------------------------------
    // CERBERUS
    // -------------------------------------------------------------------------
    block(col3, row4, x, y, "ADC Driver", orange-fill)

    block(col4, row4, x, y, "ADCX", orange-fill)
    block(col1, row5, x, y, "DataAcquisition", orange-fill)
    block(col2, row5, x, y, "EnduroSat Antenna IU", orange-fill)
    block(col3, row5, x, y, "EnduroSat EPS II", orange-fill)

    block(col4, row5, x, y, "EnduroSat Solar Panels", orange-fill)
    block(col1, row6, x, y, "ExperimentDataStore", orange-fill)
    block(col2, row6, x, y, "Flash Driver", orange-fill)
    block(col3, row6, x, y, "Patch", orange-fill)

    block(col4, row6, x, y, "Heater Manager", orange-fill)
    block(col1, row7, x, y, "StateManager", orange-fill)
    block(col2, row7, x, y, "SystemEventManager", orange-fill)

    // -------------------------------------------------------------------------
    // LEGEND
    // -------------------------------------------------------------------------
    let legend-row1 = row7 - rowspace - 0.25
    let legend-row2 = row7 - 2 * rowspace - 0.25

    block(
      col1,
      legend-row1,
      x,
      y,
      "F Prime Common",
      blue-fill,
    )

    block(
      col2,
      legend-row1,
      x,
      y,
      "F Prime FreeRTOS",
      red-fill,
    )

    block(
      col3,
      legend-row1,
      x + 0.6,
      y,
      "F Prime STM32H7XXX",
      purp-fill,
    )

    block(
      col4,
      legend-row1,
      x,
      y,
      "Open Source",
      yellow-fill,
    )

    block(
      col1,
      legend-row2,
      x,
      y,
      "Cerberus",
      orange-fill,
    )
  })
]

]
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/wrap-it:0.1.1": wrap-content

#let architecture-diagramses = box(
  // Space between the prose and the diagram.
  inset: (
    left: 1.5em,
    bottom: 0.8em,
  ),

  canvas(length: 0.7cm, {
    import draw: *

    let w = 18
    let h = 2.4
    let gap = 1.4

    let draw-layer(y, name, label, fill-col) = {
      rect(
        (0, y),
        (w, y + h),
        name: name,
        fill: fill-col,
        stroke: black + 1pt,
        radius: 0.12,
      )

      content(
        name,
        text(
          weight: "bold",
          size: 24pt,
          label,
        ),
      )
    }

    draw-layer(
      h + gap,
      "bsp",
      "Test Case",
      color.luma(218),
    )

    draw-layer(
      2 * (h + gap),
      "hal",
      "Command/Telemetry Product",
      color.luma(205),
    )

    draw-layer(
      3 * (h + gap),
      "rtos",
      "FSW State/Guard",
      color.rgb("#d4e1f9"),
    )

    draw-layer(
      4 * (h + gap),
      "osal",
      "Flight Rule",
      color.rgb("#f9d4d4"),
    )

    draw-layer(
      5 * (h + gap),
      "fw",
      "CONOPS Phase",
      color.luma(225),
    )

    draw-layer(
      6 * (h + gap),
      "app",
      "Mission Objective",
      color.rgb("#f9ebd4"),
    )

    for i in range(1, 6) {
      let y1 = i * (h + gap) + h
      let y2 = (i + 1) * (h + gap)

      line(
        (w / 2, y1),
        (w / 2, y2),
        stroke: black + 4pt,
        mark: (start: "stealth"),
      )
    }
  }),
)

#let system-architectureses = [
  #wrap-content(
    architecture-diagram,
    align: top + right,
    column-gutter: 0pt,
  )[
            *Initialization state* is entered after deploying from the launcher. Detumbling executes until reaching stable body rates, followed by the deployment of the antenna and solar panels. The spacecraft then sends its first beacon for ground station connection. During this state, early subsystem setup takes place. 

  
             * Safe state* is entered whenever the spacecraft is undergoing degraded health. The spacecraft operates with minimum required functionality regarding power, communication, and recoverability. Once the spacecraft returns to acceptable conditions, a transition is made into idle. Commands can still be queued, but execution is deferred until transitioning into the appropriate state. 

              *Idle state* is the nominal state, performing health checks, peripheral polling, memory scrubbing, and ground-contact monitoring. Experiment commands can be queued, but execution is delayed until guards for the experiment state are satisfied.  

              *Experiment state* is entered upon satisfying requirements for mission phase, resource state, payload readiness, and data-storage. This state contains setup, execution, and closeout substates. Once operator inputs for OHP variant, sunlight phase, and heater power level are verified, and once the temperature, power margin, attitude stability, and storage availability meet requirements, a transition to execution is made for thermal data collection. At closeout, data is stored and a transition to idle is made.
              === Transmit state
              A transition to transmit state is made from idle once ground-station contact is made to downlink mission data and receive commands. Lost contact causes a transition to idle. 
  ]
]

#let mission-sw = [
      ==== Tools and Methodology

    Cerberus uses F Prime with FreeRTOS on an STM32H7 onboard computer.
    A reusable support layer integrates F Prime with FreeRTOS, CMSIS,
    ST HAL, startup code, linker configuration, and peripheral drivers
    while keeping mission software independent of the selected board.

    ==== F Prime Common Services

    F Prime services provide command dispatch, sequencing, telemetry,
    event logging, communication framing, and file transfer. These
    services form the spacecraft command and data-handling path between
    the ground system, flight components, radio, and onboard storage.

    ==== FreeRTOS and STM32 Platform Support

    FreeRTOS schedules command processing, health monitoring, telemetry,
    payload sampling, and storage operations. Priority-based execution
    allows safety and health functions to preempt payload and
    communication activities when spacecraft conditions degrade.

    ==== Cerberus Mission Components

    StateManager controls transitions among Initialization, Safe, Idle,
    Experiment, and Transmit, while SystemEventManager enforces
    CONOPS-derived health and readiness rules. Mission components manage
    heater control, data acquisition, flash storage, and interfaces to
    the EPS, solar panels, antenna, transceiver, ADCSX, and payload
    electronics. Ground-authorized software patches are permitted only
    in Idle after validation against mission intent.

    ==== Testing and Verification

    Verification includes GTest unit tests, deployment on
    processor-representative and flight hardware, and subsystem
    integration testing in Linux and embedded environments. Testing
    validates state behavior, hardware interfaces, telemetry, storage,
    packetization, transmission, resource use, and assertion-free
    operation under nominal and off-nominal conditions.
     *Initialization state* is entered after deploying from the launcher. Detumbling executes until reaching stable body rates, followed by the deployment of the antenna and solar panels. The spacecraft then sends its first beacon for ground station connection. During this state, early subsystem setup takes place. 
]