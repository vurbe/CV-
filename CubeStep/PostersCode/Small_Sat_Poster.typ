#import "@preview/simple-research-poster:0.1.0": *
#import "colors.typ": base-colors
#import "Sections.typ": abstract-smcit, software-states, references, system-architecture, SwModulesDiagram, ExperimentalSubModule, traceability-figure, implementation-map, future-work,authority-boundaries,acknowledgements, mission-sw

#show: poster.with(
  title:       [Mission Orientated Flight Software Development: CubeSTEP],
  author:      [Tirth Thakkar, Howard Lee, Viren Kumar, Maranda Laws, \ Shridhi Seth, Marco Maggia, Navid Nakhjiri],

  // A0 = 841 × 1189 millimeters
  width:       1189mm,
  height:      841mm,
  subtitle:    [California Polytechnic University, Pomona],
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
  // Master layout grid defining the 3 primary visual columns of the poster
  grid(
    columns: (1fr, 1fr, 1fr), 
    gutter: cgutter,

    // =========================================================================
    // VISUAL COLUMN 1: Items flow and stack naturally without row constraints
    // =========================================================================
    [
      #colored-poster-section(fill: true)[Introduction][
        #abstract-smcit
      ]
      #v(cgutter) // Keeps spacing consistent between stacked blocks
     #colored-poster-section[CONOPS][#authority-boundaries]
     
    #colored-poster-section(fill: true)[Mission Software Architecture][#system-architecture], 

    ],

    // =========================================================================
    // VISUAL COLUMNS 2 & 3: Nested sub-grid to handle the spanning diagram
    // =========================================================================
    grid.cell(
      colspan: 2,
      grid(
        columns: (1fr, 1fr),
        gutter: cgutter,
        
        // Top level of Columns 2 and 3
         //colored-poster-section(fill: true)[Future Work & Flight Readiness][#future-work],
        colored-poster-section[Flight Software Implementation][#SwModulesDiagram],


            colored-poster-section(fill: true)[Mission Software][#mission-sw],
      
        // Spanning Block: This takes up the full width of Col 2 & 3 mid-way down
        grid.cell(
          colspan: 2,
          colored-poster-section[Mission Software  Behavioral Logic][#software-states],
          
        ),
      
        

        colored-poster-section[Acknowledgements][#acknowledgements],

            colored-poster-section(fill: true)[References][#references], 

      )
    )
  ),
  top: 0.3cm,
  x: 1in,
)
