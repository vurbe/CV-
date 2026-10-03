#import "@preview/simple-research-poster:0.1.0": *
#import "../2ndOrderStationaryPoster/colors.typ": base-colors
#import "../2ndOrderStationaryPoster/sections.typ": section1,section2,section3,section4,acknowledgements,references, section5 
#show: poster.with(
  title:       [Finding 2nd order stationary markov processes],
  author:      [Viren Kumar, Hasan Khan ],
  mentor:      [Alan Krinik],
  //poster size max is 41x41 + minimum font size is 18
  width:       42in,
  height:      42in,
  subtitle:    [California Polytechnic Institute, Pomona],
  logo:        image("../assets/logo.png", height: 100%),
  base-colors: base-colors
)

#let colored-poster-section = poster-section.with(base-colors: base-colors)

#pad(
  grid(
    columns: 2,
    inset: 0.2in,
    gutter: 20pt,
    [ // COLUMN 1
#set text(size: 28pt)
      #colored-poster-section(fill: true)[Definitions][#section1]
      
      #colored-poster-section[ The Inciting Idea][#section5]
#set text(size: 22pt)    
      #colored-poster-section(fill: true)[Proof for 3 Node Birth-Death Chain][#section2]


    ],
    [ // COLUMN 2
#set text(size: 27pt)
      #colored-poster-section[What about other 3 node Markov processes?][#section3]
#set text(size: 35pt)
      #colored-poster-section(fill: true)[Further Steps and Exploration into Generalization][#section4]

      #colored-poster-section(fill: true)[References][#references]
      
      #colored-poster-section[Acknowledgements][#acknowledgements]

    ],
    [ // COLUMN 3 (Merged Applications, Synopsis, and 
      
    ]
  ),
  top: 0.5in,
  x: 1in,
)