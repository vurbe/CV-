#let section1 = [
  A stochastic process $X(t)$ is second-order stationary if:

  1. *$E[X(t)] = mu$ (a constant).*

  2. *$"Cov"(X(s), X(t)) = r_X(|t - s|)$.*
  
]
  

#let section2 = [
  We will informally show that a 3 node birth death chain is second order stationary, while the general case can just as easily have been shown here, I opted for a numerical example to hopefully be more easy to follow for the reader. Take the following Markov process. 

    #import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#figure(
  diagram(
    node-defocus: 0,
    spacing: 9cm,
    edge-stroke: 3pt,
    node-fill: luma(97%),
    node-outset: 10pt,

    // Define the states as nodes
    node((0,0), [0], name: <n0>, radius: 1cm, stroke: 1.5pt),
    node((1,0), [1], name: <n1>, radius: 1cm, stroke: 1.5pt),
    node((2,0), [2], name: <n2>, radius: 1cm, stroke: 1.5pt),

    {
      // Custom function based on your working example
      // Using 'left' for label-side keeps the label on the outside of the curve
      let transition(a, b, label, paint) = {
        edge(a, b, label, "-|>", stroke: paint, bend: 30deg, label-side: left)
      }

      // Birth transition: 0 -> 1 with rate lambda
      transition(<n0>, <n1>, $1$, blue)
      transition(<n1>, <n2>, $2$, blue)
      
      // Death transition: 1 -> 0 with rate mu
      transition(<n1>, <n0>, $2$, red)
      transition(<n2>, <n1>, $1$, red)
    }
    
  ),
  caption: [A birth Death Process :)]
)
  The steady state of this birth death chain is $arrow(pi) = [2/5 , 1/5 , 2/5]$
  
  The p-matrix for this process is: $ e^(-5t) / 10 mat(
  5 e^(4t) + 4 e^(5t) + 1, -2(1 - e^(5t)), -5 e^(4t) + 4 e^(5t) + 1;
  -4(1 - e^(5t)), 2(e^(5t) + 4), -4(1 - e^(5t));
  -5 e^(4t) + 4 e^(5t) + 1, -2(1 - e^(5t)), 5 e^(4t) + 4 e^(5t) + 1
) $
  Given that the initial state of the Markov process is at its steady state we will show that $E[X(t)]= mu$ for all of t. 

  To prove the mean is constant, we first need to find the probability distribution of $X(t)$ for all of t, of each state. 

  We can use the Total Law of Probability to find probability at state 0
  $ P(X(t)=0) = P(X(0)=0,X(t)=0)+P(X(0)=1, X(t)=0)+P(X(0)=2, X(t)=0) $

  Note that $P(a,b) = P(a)dot P(b|a)$
  
  $ = 2/5 P_(0,0)(t) + 1/5 P_(0,1)(t)+2/5 P_(2,0)(t) = 4/25 + 2/25 + 4/25 = 2/5 $ (I know I am skipping steps but the equation went off the screen)

  Doing the same thing for state 1 and state 2 we have 
  $ P(X(t)=2) = 2/5 ; P(X(t) = 1) = 1/5 $

  Thus $ E(x(t)) = 0*2/5 + 1*1/5 + 2*2/5 = 1 $ which is a constant

  Now we will show that the Covariance is determined only by difference in time of the elements we are comparing. (This is the hard part) 

  #let cov = $op("Cov")$

  Without loss of generality assume $s < t$ then $cov(X(s), X(t))$
  $ = E[X(s) dot X(t)] - E[X(s)] dot E[X(t)] = E[X(s) dot X(t)] - 1 dot 1 $

  Consider the joint distribution table of $[X(s), X(t)]$

  #align(center, table(
  columns: (auto, 1.5cm, 8.5cm, 8.5cm),
  stroke: none,
  align: center + horizon,
  table.header([$X(s) \\ X(t)$], [0], [1], [2]),
  table.hline(),
  [0], [---], [---], [---],
  [1], [---], [$P[X(s)=1, X(t)=1]$], [$P[X(s)=2, X(t)=1]$],
  [2], [---], [$P[X(s)=1, X(t)=2]$], [$P[X(s)=2, X(t)=2]$],
  ))

  $ cov(X(s), X(t)) = P[X(s)=1, X(t)=1] + 2 P[X(s)=2, X(t)=1] + 2 P[X(s)=1, X(t)=2] + 4 P[X(s)=2, X(t)=2] $

  Simplifying we get 
  $ cov(X(s), X(t)) = 1/5(P_(1,1))(t-s)+4/5(P_(2,1)(t-s))+2/5(P_(1,2)(t-s))+8/5(P_(2,2)(t-s))-1 $
  Note that the Covariance is a composition of (t-s) as desired

  We have shown that the Markov process is second order stationary. $square$
  ]

  #let section3 = [
  Looking into the following Markov process, we can easily show that given it starting at its steady state that its expected value at any point of in time will be its steady state (as that is the definition of a steady state)

  #import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

  #figure(
  diagram(
    node-defocus: 0,
    spacing: 9cm,
    edge-stroke: 3pt,
    node-fill: luma(97%),
    node-outset: 10pt,

    // Define the states as nodes
    node((0,0), [0], name: <n0>, radius: 1cm, stroke: 1.5pt),
    node((1,0), [1], name: <n1>, radius: 1cm, stroke: 1.5pt),
    node((2,0), [2], name: <n2>, radius: 1cm, stroke: 1.5pt),

    {
      // Custom function based on your working example
      // Using 'left' for label-side keeps the label on the outside of the curve
      let transition(a, b, label, paint) = {
        edge(a, b, label, "-|>", stroke: paint, bend: 30deg, label-side: left)
      }

      // Birth transition: 0 -> 1 with rate lambda
      transition(<n0>, <n2>, $2$, blue)
      
      
      // Death transition: 1 -> 0 with rate mu
      transition(<n1>, <n0>, $1$, red)
      transition(<n2>, <n1>, $1$, red)

      let loop(a, b, label, paint) = {
       edge(a, b, label, "-|>", stroke: paint, bend: 130deg, label-side: left)
      }

      //loop(<n0>, <n0>, $lambda_1$, blue)
    }
    
  ),
  caption: [A pretty P matrix generating Markov process]
)
  The P Matrix is: $ e^(-2t) / 5 mat(
  2 e^(2t) + sin(t) + 3 cos(t), e^(2t) - 2 sin(t) - cos(t), 2 e^(2t) + sin(t) - 2 cos(t);
  -2(-e^(2t) - 3 sin(t) + cos(t)), e^(2t) - 2 sin(t) + 4 cos(t), -2(-e^(2t) + 2 sin(t) + cos(t));
  -2(-e^(2t) + 2 sin(t) + cos(t)), e^(2t) + 3 sin(t) - cos(t), 2 e^(2t) + sin(t) + 3 cos(t)
  ) $

  The steady state of this birth death chain is $arrow(pi) = [2/5 , 1/5 , 2/5]$ (yes I did pick a Markov chain that has the same steady state)

    Thus we will jump to showing that the Covariance satisfies the conditions of a second order stationary process 
  
    Without loss of generality assume $s < t$ then $"cov"(X(s), X(t))$
  $ = E[X(s) dot X(t)] - E[X(s)] dot E[X(t)] = E[X(s) dot X(t)] - 1 $
  
  Consider the joint distribution table of $[X(s), X(t)]$
  
  #align(center, table(
    columns: (auto, 1.5cm, 9.5cm, 9.5cm),
    stroke: none,
    align: center + horizon,
    table.header([$X(s) \\ X(t)$], [0], [1], [2]),
    table.hline(),
    [0], [---], [---], [---],
    [1], [---], [$P[X(s)=1, X(t)=1]$], [$P[X(s)=1, X(t)=2]$],
    [2], [---], [$P[X(s)=2, X(t)=1]$], [$P[X(s)=2, X(t)=2]$],
  ))
  
  $ "cov"(X(s), X(t)) = P[X(s)=1, X(t)=1] + 2 P[X(s)=2, X(t)=1] + 2 P[X(s)=1, X(t)=2] + 4 P[X(s)=2, X(t)=2] - 1 $
  
  Simplifying we get 
  $ "cov"(X(s), X(t)) = 1/5(P_(1,1))(t-s)+4/5(P_(2,1)(t-s))+2/5(P_(1,2)(t-s))+8/5(P_(2,2)(t-s)) -1 $
  Note that the covariance is a composition of (t-s) as desired
  
  We have shown that the Markov process is second order stationary. $square$


  
]

#let section4 = [
  While I could love to make the statement that any Markov process is second-order stationary *if and only if* it is initialized in its stationary distribution $pi$. There is far more work to be done to assume this is a correct assertion. 
  
  *Potential Avenues of Exploration*
  The goal is to try and identify generalizing patterns in the approaches in finding Markov processes as second order stationary 
   - Examining different structures of Markov chains 
   - Expanding to N-size Markov chains 
   - Exploration into non-homogenous Markov chains with a steady state
]


#let acknowledgements = [
  Special acknowledgements to the people in the Michael Green Room for providing a work environment and Professor Alan Krinik for being the inciting event for this idea, as well as for the plenty of help given along the way.  
]

#let references = [
  #bibliography("../2ndOrderStationaryPoster/references.bib", title: [], full: true)
]

#let section5 = [
In chapter 4.2 of Hoel Port and Stone, there is a proof showing that if a 2 state birth death chain starts at its steady state, it is 2nd order stationary. 
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#figure(
  diagram(
    node-defocus: 0,
    spacing: 9cm,
    edge-stroke: 3pt,
    node-fill: luma(97%),
    node-outset: 10pt,

    // Define the states as nodes
    node((0,0), [0], name: <n0>, radius: 1cm, stroke: 1.5pt),
    node((1,0), [1], name: <n1>, radius: 1cm, stroke: 1.5pt),

    {
      // Custom function based on your working example
      // Using 'left' for label-side keeps the label on the outside of the curve
      let transition(a, b, label, paint) = {
        edge(a, b, label, "-|>", stroke: paint, bend: 30deg, label-side: left)
      }

      // Birth transition: 0 -> 1 with rate lambda
      transition(<n0>, <n1>, $lambda$, blue)
      
      // Death transition: 1 -> 0 with rate mu
      transition(<n1>, <n0>, $mu$, red)
    }
    
  ),
  caption: [A confirmed 2nd order stationary process]
)


The natural question is then ask if this is true for a 3 node birth-death process, or any 3 node chain in ? 
  
]