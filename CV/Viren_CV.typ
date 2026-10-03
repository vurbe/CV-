
#import "Colors.typ": *

#show: body => resume_style(body, font_size: 10pt, margin: (x: 0.62in, y: 0.55in), page_numbers: true)

#align(center)[
  #text(size: 22pt, weight: "bold")[Viren Kumar]
  #v(-1em)
  (858) 413-4017 | virenkumar\@cpp.edu | US Citizen | #link("https://linkedin.com/in/viren-kumar-cpp/")[linkedin.com/in/viren-kumar-cpp/]
]


== Objective
 Undergraduate in Computer Engineering and Applied Mathematics seeking higher level work with Markov Chains, Mathematical Modeling, and Systems Optimization in applied problems. 

== Education
#grid(
  columns: (1fr, auto),
  [#text(weight: "bold")[California State Polytechnic University, Pomona]], [#text(weight: "bold")[August 2024 -- May 2027 expected]],
)
#v(-0.2em)
#grid(
  columns: (80pt, 1fr),
  row-gutter: 0.25em,
  [Dual Major:], [Bachelor of Science, Computer Engineering],
  [], [Bachelor of Science, Applied Mathematics],
)

//== Research Interests
//- Computational methods for large-scale physical and engineered systems
//- Numerical linear algebra, stochastic processes, and stability analysis
//- Embedded systems, flight software, FPGA prototyping, and hardware/software co-design
//- Secure communication, post-quantum cryptography, and verification under resource constraints
//-Finance And Economics, Modeling, Analysis, and Investing Theory (Famma-French) Volitility Analysis

== Research and Technical Experience
#cv_entry(
  title: "McNair Scholar and Undergraduate Researcher",
  entity: "McNair Scholars Program | Cal Poly Pomona",
  date: "August 2025 -- Present",
  location: "Pomona, CA",
)[
  - Conducted research under Dr. Aly on post-quantum encryption for CubeSat communication as part of the NASA ORBIT competition.
  - Focused on structural and mathematical validation of Applying ASCON to the Kyber protocols, including  using group theory to verify monoid behavior and lattice-like structure.
  - Phase III contestant with team presenting work at Johnson Space Center in Houston.
]

#cv_entry(
  title: "CubeSTEP Flight Software Lead",
  entity: "CubeSTEP | Cal Poly Pomona",
  date: "December 2025 -- Present",
  location: "Pomona, CA",
)[
  - Collaborate with the JPL F' team to develop flight-ready software for an incoming satellite mission.
  - Co-author of paper and presented poster on "Mission-Oriented Flight Software Development: CubeSTEP," for SMC-IT 2026.
  - Promoted to software lead due to exceptional performance on August 2026
]
/*

#cv_entry(
  title: "STARS REU Research Participant",
  entity: "McNair | Cal Poly Pomona",
  date: "June 2026 -- August 2026",
  location: "Pomona, CA",
)[
  - Formalized work done in SSCS Chipathon 2026 competition as part of RISC-V Business Team 
  - Wrote and presented paper on Formalizing a pipeline to rapidly map efficient AI designs into ASIC using google CFU playground
]

*/
#cv_entry(
  title: "Research Volunteer",
  entity: "NCUHS | UCLA",
  date: "June 2025 -- August 2025",
  location: "Los Angeles, CA",
)[
  - Collaborated with Dr. Guido Faas on fabrication of micro-sensors and chips for implantation in mice for pain and migraine research.
  - Supported chip handling, microfabrication preparation, and technical lab workflows in a biomedical research setting.
]
/*
#cv_entry(
  title: "McNair REU Research Participant",
  entity: "McNair | Cal Poly Pomona",
  date: "June 2025 -- July 2025",
  location: "Pomona, CA",
)[
  - Conducted a literature review on thermal design optimization for mobile devices, integrating hardware, programming, and design perspectives.
  - Wrote and presented a research proposal on thermal optimization and sustained mobile-device performance.
]
*/
#cv_entry(
  title: "Founding Member and Thermal Engineering Lead",
  entity: "CPP Smartphone Project | Cal Poly Pomona",
  date: "August 2024 -- December 2025",
  location: "Pomona, CA",
)[
  - Helped establish project scope and secure funding for a student-led effort to design a smartphone system using FPGA prototyping.
  - Led a five-person thermal engineering team focused on body design, thermal management, and sustained performance.
  - Coordinated with hardware, system-on-chip, and systems teams to manage thermal and energy budgets; used FreeCAD and Ansys for design iteration.
]

#cv_entry(
  title: "CPP Problem Solving Team Member",
  entity: "Problem Solving Team | Cal Poly Pomona",
  date: "Spring 2024 -- Present",
  location: "Pomona, CA",
)[
  - Solve problems from mathematical journals and prepared formal solutions in LaTeX for submission.
  - Personally submitted verified solutions to CRUX, PME, and CMJ.
  - Became main point of contact for proof-writing and inequality problem solving.
]

#cv_entry(
  title: "Materials Engineering Intern",
  entity: "LyTen Inc.",
  date: "June 2022 -- August 2022",
  location: "San Jose, CA",
)[
  -  worked on creating and testing various composites impregnated with different variations of Graphene nanoplateles 
  - Through labwork formalized and presented a method to filter for grain size with a 70% higher yeild, data was organized and calculated through matlab and excel and presented via powerpoint. 
]
#pagebreak()

== Publications and Manuscripts
#compact_entry(
  title: "Mission-Oriented Flight Software Development: CubeSTEP",
  date: "August 5, 2026",
)[
  - 2nd Co-author; publication for SMC-IT 2026.
]
#compact_entry(
  title: "From TinyML Model to Open Silicon, A CFU Playground Pipeline for AI design on GF180MCU ",
  date: "August 12, 2026",
)[
  - 1st Author; publication for STARS 2026.
]
#compact_entry(
  title: "Ascon-Kyber for Quantum-Resilient Space Telemetry",
  date: "May 22, 2026",
)[
  - 1st author; publication for McNair Symposium 2026.
]
#v(-.4em)
== Presentations, Panels, and Selected Talks
#compact_entry(
  title: "Various Steady State Properties of Markov Chains and Processes",
  date: "Nov 5 2026",
)[
  - Set to present at research and progress on various steady state properties of Markov Chains, at MAA Southern California-Nevada Section Fall Meeting, 2026 AMS Fall Wester Sectional Meeting, and JMM 2027.
]
#compact_entry(
  title: "MDO to Software Deign",
  date: "August 5 2026",
)[
  - Presented poster at SMC-IT with same name as submitted paper. Focused on methodology for turning MDO(Mission Design Optimizations) into actionable software procedures.
]
#compact_entry(
  title: "Markov Processes and Weak Stationarity",
  date: "April 15, 2026",
)[
  - Presented a lemma showing that a Markov process at steady state is weakly stationary. At Cal Poly Pomona's 2026 Science Symposium.
]
#compact_entry(
  title: "Quaterions: An introduction of Abstract Structures",
  date: "April 8, 2026",
)[
  - Presented a poster on Cayley–Dickson constructions at SIAM 2026 Symposium at Cal Poly Pomona]
#compact_entry(
  title: "AI Subject Matter Expert Panelist",
  date: "June 4, 2025",
)[
  - Panelist as an AI subject matter expert for the OAI Faculty and Staff Summer Conference for the Cal Poly Pomona Student Perspectives on the AI-Driven Future of Education and Work for STEM to Social Science Fields event.
]

#compact_entry(
  title: "Thermal Design Optimization for Mobile Devices",
  date: "August 7, 2025",
)[
  - Presented research proposal at CARS Conference, Cal Poly Pomona.
]

#compact_entry(
  title: "Negative Probabilites in Markov Chains",
  date: "October 27, 2024",
)[
  - Presented Dr. Krinik's research at the Fall Western Sectional Meeting, University of California, Riverside.
]




#v(-.4em)

== Other Conferences and Workshops
- Forum for Diversity in Graduate Education, University of California, SCSU, October 3, 2026
- 12th International Conference on Space Mission Challenges for Information Technology (SMC-IT),August 3--6  2026
- 5th Annual Quantum Engineering Workshop, University of Southern California, May 29, 2025
- IPAM PUMA: Practicum for Undergraduate Mathematicians in Topology, UCLA, April 12--13, 2025
- Forum for Diversity in Graduate Education, University of California, Riverside, October 19, 2024
- 4th Annual Quantum Engineering Workshop, University of Southern California, May 30, 2024

== Selected Coursework
#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  [
    #text(weight: "bold")[Mathematics and Statistics]
    - MAT 5300: Random Processes
    - MAT 4010: Numerical Analysis I
    - MAT 4190: Advanced Linear Algebra
    - MAT 4170: Abstract Algebra I
    - MAT 3470: Combinatorics
    - MAT 3140: Real Analysis I
    - MAT 4990: Introduction to Mathematical Research with negative states in Markov chains
  ],
  [
    #text(weight: "bold")[Electrical and Computer Engineering]
    - ECE 4300: Computer Architecture
    - ECE 3300/L: Digital Circuit Design with Verilog
    - ECE 2200/L: Microelectronic Circuits
    - ECE 3101/L: Signals and Systems
    - ECE 2300/L: Digital Logic Design
    - ECE 2101/L: Electrical Circuit Analysis II
    - ECE 4990: Engineering Research: Computer Vision
    - ECE 4990: Engineering Research:  Wireless and Mobile Systems
  ],
)
/*
== Skills
- #text(weight: "bold")[Programming:] C++, C, Python, MATLAB, Verilog, SystemVerilog, F', C\#
- #text(weight: "bold")[Software and Engineering Tools:] Visual Studio, Vim, LaTeX, Typst, LTspice, FreeCAD, Vivado, MPLAB X IDE, Linux,
- #text(weight: "bold")[Fabrication and Hardware:] Laser cutting, 3D printing, 3D scanning, KiCad, soldering, micro-soldering, LibreLane
- #text(weight: "bold")[Technical Writing:] MS Office Suite, LibreOffice, Typst, Overleaf, Zotero, Obsidian
*/
== Memberships, Affiliations, and Service
#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  [
    - McNair Scholars Program
    - Engineering BRIDGE
    - SIAM Vice President and Communications Liasion
    - CSU-SPARA
  ],
  [
    - RAMP: Reading, Advising, and Mentoring Program
    - MEP-WISE: Maximizing Engineering Potential
    - CPP branch IEEE Secretary
  ],
)

