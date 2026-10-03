
#import "@preview/simple-research-poster:0.1.0": *
#import "colors.typ": base-colors
#import "Sections.typ": abstract-intro, implementation-map, future-work, software-states, references, system-architecture, osal-adaptation, SwModulesDiagram, current_progress,architecture-diagramses 

#show: poster.with(
  title:       [Adapting NASA F Prime with FreeRTOS for STM32-Based Embedded Flight Software],
  author:      [Tirth S. Thakkar, Howard S. Lee, Viren Kumar, Navid Nakhjiri, Marco Maggia],
  
  // A0 = 841 × 1189 millimeters
  width:       1189mm,
  height:      841mm,
  subtitle:    [California State Polytechnic University, Pomona],
  logo: image("../assets/CubeSTEP Logo.png"),
  base-colors: base-colors
)

#place(
  top + left,
  dx: 7.4cm, 
  dy: -9.0cm, 
  image("../assets/nasa.png", height: 7cm)
)

#place(
  top + right,
  dx: -7.4cm,  
  dy: -9.0cm,
  image("../assets/CubeSTEP Logo.png", height: 7cm)
)

#let colored-poster-section = poster-section.with(base-colors: base-colors)

#set text(
  size: 24pt,
)

#set par(justify: true)

#let rgutter = 0cm
#let cgutter = 0pt

#pad(
  grid(
    columns: 3,
    inset: 0in,
    gutter: 50pt,
    [ // COLUMN 1
      #colored-poster-section(fill: true)[Introduction][#abstract-intro]
      #colored-poster-section[OSAL Adaptation & Embedded Challenges][#osal-adaptation]
      #colored-poster-section(fill:true)[System Architecture][#system-architecture]

    ],
    [ // COLUMN 2

       #colored-poster-section[Current Progress & Results][#current_progress]


      #colored-poster-section(fill: true)[F'+FreeRTOS Implimentation][#implementation-map]
    
      #colored-poster-section[Future Work and Flight Readiness][#future-work]

            #colored-poster-section(fill:true)[Acknowledgements][The authors acknowledge Celeste Smith and the F Prime team at the NASA Jet Propulsion Laboratory for the support throughout this work. The authors also extend thanks to, Jeffrey W. Levison, Kevin Ortega, Dr. Takuro Daimaru, Dr. Scott Roberts, and Dr. Jeremiah Gayle for their technical guidance, encouragement, and continued support.This work was supported by the NASA Minority University Research and Education Project (MUREP) under Grant No. 80NSSC23M0223.hello]

    ],
    [ // COLUMN 3 (Merged Applications, Synopsis, and References)


      #colored-poster-section(fill: true)[Software Architecture][#SwModulesDiagram] 

      #colored-poster-section[Conclusion][This work demonstrates that F Prime can be extended beyond conventional Linux/POSIX-style deployments to constrained STM32/FreeRTOS spacecraft hardware. By adapting the OSAL, board initialization, memory configuration, and execution model, the project preserves F Prime’s command, telemetry, scheduling, and fault-management structure while enabling deployment on the EnduroSat OBCI pathway. 

The current result is a functioning embedded F Prime/FreeRTOS baseline for CubeSTEP-Cerberus. The next step is to convert this bring-up into a flight-ready software baseline through subsystem integration, software-in-the-loop testing, hardware-in-the-loop testing, and long-duration runtime characterization.]


      
      #colored-poster-section(fill: true)[References][#references]
      
    ]
  ),
  top: 0.5in,
  x: 1in,
)
/*
currently a newboot implimentation provided a proof of conecpet on the endurosac OBCI, we are now able ot evaluate system viability now we are focusing on system integration: revilation: 

ESTTC (EndurosatTransferProtocol ) (multi-droop: RS485) Framing structure using: Similar to I2C that you have an adress in the connection on the line according to the structure the device expects at a preset baud rate. 

So we need connection w specific data sequence and the scrambling stuff. (Required in ESTTC so we are encrypted). 
*/