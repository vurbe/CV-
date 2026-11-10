// Shared style, colors, and macros for  Typst documents.

#let accent = rgb("#1f4e79")
#let text_color = rgb("#111111")
#let light_rule = luma(82)

#let name = "Viren Kumar"
#let phone = "(858) 413-4017"
#let email = "virenkumar@cpp.edu"
#let citizenship = "US Citizen"
#let linkedin_url = "https://linkedin.com/in/viren-kumar-cpp/"
#let linkedin_text = "linkedin.com/in/viren-kumar-cpp/"

// Apply this with:
// #show: body => resume_style(body, font_size: 10pt, margin: (x: 0.62in, y: 0.55in), page_numbers: true)
#let resume_style(body, font_size: 10.5pt, margin: (x: 0.6in, y: 0.6in), page_numbers: false) = {
  set page(
    paper: "us-letter",
    margin: margin,
    numbering: if page_numbers { "1" } else { none },
  )
  set text(font: "Atkinson Hyperlegible Next", size: font_size, fill: text_color)
  set par(justify: true, leading: 0.58em)
  set list(indent: 0.55em, body-indent: 0.55em)

  show heading.where(level: 2): it => [
    #set text(size: 12pt, weight: "bold", tracking: 0.5pt, fill: accent)
    #v(0.1em)
    #upper(it.body)
    #v(-0.75em)
    #line(length: 100%, stroke: 0.5pt + light_rule)
    #v(-0.25em)
  ]

  show heading.where(level: 3): it => [
    #set text(size: 10.5pt, weight: "bold", fill: accent)
    #v(0.2em)
    #it.body
    #v(-0.35em)
  ]

  body
}

// Apply this with:
// #show: body => essay_style(body)
#let essay_style(body, font_size: 11pt, margin: (x: 0.85in, y: 0.75in), page_numbers: true) = {
  set page(
    paper: "us-letter",
    margin: margin,
    numbering: if page_numbers { "1" } else { none },
  )
  set text(font: "Atkinson Hyperlegible Next", size: font_size, fill: text_color)
  set par(first-line-indent: 0.25in, spacing: 0.72em, justify: true, leading: 0.6em)
  set list(indent: 0.55em, body-indent: 0.55em)

  body
}

#let sep = [#h(0.42em)|#h(0.42em)]

#let contact_line() = [
  #phone #sep #link("mailto:" + email)[#email] #sep #citizenship #sep #link(linkedin_url)[#linkedin_text]
]

#let document_header(title: none, subtitle: none, name_size: 22pt) = [
  #align(center)[
    #text(size: name_size, weight: "bold")[#name]
    #v(-0.65em)
    #contact_line()
    #if title != none [
      #v(0.35em)
      #text(size: 13pt, weight: "bold", fill: accent)[#title]
    ]
    #if subtitle != none [
      #v(-0.45em)
      #text(size: 10pt)[#subtitle]
    ]
  ]
  #v(0.15em)
]

#let cv_entry(title: "", entity: "", date: "", location: "", body) = [
  #block[
    #grid(
      columns: (1fr, auto),
      gutter: 0.75em,
      [#text(weight: "bold")[#title]], [#text(weight: "bold")[#date]],
      [#entity], [#location],
    )
    #v(-0.42em)
    #body
  ]
  #v(-0.2em)
]

#let compact_entry(title: "", date: "", body) = [
  #block[
    #grid(
      columns: (1fr, auto),
      gutter: 0.75em,
      [#text(weight: "bold")[#title]], [#text(weight: "bold")[#date]],
    )
    #v(-0.45em)
    #body
  ]
  #v(-0.25em)
]

#let item_line(left: "", right: "") = [
  #grid(
    columns: (1fr, auto),
    gutter: 0.75em,
    [#left], [#right],
  )
]

#let essay_header(title: "", subtitle: none) = [
  #align(center)[
    #text(size: 18pt, weight: "bold")[#name]
    #v(-0.55em)
    #text(size: 12pt, weight: "bold", fill: accent)[#title]
    #if subtitle != none [
      #v(-0.45em)
      #text(size: 10pt)[#subtitle]
    ]
  ]
  #v(0.25em)
]
