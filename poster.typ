// ============================================================================
// Academic Poster: Physics-Informed Generative World Models for Real-Time Bidding
// KDD 2026 | Typst + peace-of-posters
// ============================================================================
#import "@preview/peace-of-posters:0.5.6" as pop

// --- Page & Layout Setup ---
#set page("a0", margin: 1cm)
#pop.set-poster-layout(pop.layout-a0 + (
    // "paper":            "a0",
    // "size":             (841mm, 1188mm),
    // "body-size":        33pt,
    "heading-size":     39pt,
    // "title-size":       75pt,
    // "subtitle-size":    60pt,
    // "authors-size":     50pt,
    // "institutes-size":  45pt,
    // "keywords-size":    40pt,
))

// --- Custom Minimalist Theme ---
#let primary = rgb("#1a5276")
#let accent  = rgb("#2980b9")
#let lightbg = rgb("#f4f6f7")
#let darkfg  = rgb("#2c3e50")

#pop.set-theme((
  "body-box-args": (
    inset: 0.8em,
    width: 100%,
    stroke: 1.2pt + primary.lighten(60%),
    radius: 6pt,
    fill: white,
  ),
  "body-text-args": (fill: darkfg),
  "heading-box-args": (
    inset: 0.8em,
    width: 100%,
    fill: primary,
    radius: (top: 6pt),
  ),
  "heading-text-args": (fill: white, weight: "bold"),
  "title-box-args": (
    inset: 0.8em,
    fill: gradient.linear(primary, accent, angle: 0deg),
    radius: 8pt,
  ),
  "title-text-args": (fill: white),
))

#set text(size: 28pt, font: "New Computer Modern")
#let box-spacing = 0.8em
#set columns(gutter: box-spacing)
#set block(spacing: box-spacing)
#pop.update-poster-layout(spacing: box-spacing)

// table
#set table(align: center + horizon, stroke: none, inset: .5em)
#let tlt(..args) = table(table.hline(stroke: 1pt, y: 0), table.hline(stroke: .5pt, y: 1), ..args, table.hline(stroke: 1pt))
// ============================================================================
// TITLE
// ============================================================================
#pop.title-box(
  "Physics-Informed Generative World Models for Real-Time Bidding",
  subtitle: "Deriving Statistical Laws from First Principles",
  authors: "Chenyang Wu¹ · Tianyu Wang² · Shengjun Fang¹ · Mingjun Cao¹ · Pengfei Liu¹ · Zongzhang Zhang¹ · Yeshu Li² · Zhilin Zhang² · Chuan Yu² · Jian Xu² · Bo Zheng²",
  institutes: "¹Nanjing University       ²Alibaba Group",
  keywords: "Real-Time Bidding · Generative World Models · Physics-Informed Statistical Modeling · Normalizing Flow Copula",
  text-relative-width: 65%,
  spacing: 0pt,
  title-size: 68pt,
  subtitle-size: 48pt,
  authors-size: 30pt,
  institutes-size: 29pt,
  keywords-size: 28pt,
  logo: block(height: 300pt, align(horizon, stack(
    grid(
      columns: (1fr, 0.4fr),
      column-gutter: 1cm,
      align(right, image("base/lamda_logo.png")),
      align(right, image("base/nju_color_logo.png")),
    )
  ))),
)

#set par(justify: true)

// ============================================================================
// 3-Column Layout
// ============================================================================
#columns(3, [

// ===================== COLUMN 1 =====================

#pop.column-box(heading: "Motivation & Problem")[
  Existing RTB simulators rely on *log-domain MSE regression*, which is fundamentally ill-posed for auction data: it biases the mean (Jensen's inequality), ignores zero-inflation, heteroscedasticity, heavy tails, and tail dependence.

  *Our goal:* Estimate the full conditional joint density $P_theta (bold(y)_t | h_t, bold(b)_t, bold(c))$ that respects these properties — the indispensable simulator for offline RL in computational advertising.
]

#pop.column-box(heading: "Paper Outline")[
  // *① Marginal Modeling*
  // #block(fill: lightbg, inset: 0.4em, radius: 4pt, width: 100%)[
  //   Statistical model selection *fails* in heavy-tail regimes (Flat Minima). We instead derive distributions from *first principles* (physics-informed). Empirical evidence validates the assumptions. ZI-GB2 serves as the practical surrogate.
  // ]
  // *② Dependence Modeling*
  // #block(fill: lightbg, inset: 0.4em, radius: 4pt, width: 100%)[
  //   Cost and Value are *perfectly tail-dependent* ($lambda_u = 1$) by construction — a Gaussian copula ($lambda_u = 0$) is provably wrong. A *Normalizing Flow copula* flexibly captures the full nonlinear dependence.
  // ]
  // *③ Experimental Results*
  // #block(fill: lightbg, inset: 0.4em, radius: 4pt, width: 100%)[
  //   SOTA *distributional fidelity* on production Taobao data. Physics-informed objectives are *architecture-agnostic* and exhibit superior *neural scaling*.
  // ]

  *① Marginal Modeling*\
  #hide[① ]Physics-informed derivation; ZI-GB2 surrogate.
  
  *② Dependence Modeling*\
  #hide[② ]Perfect tail dependence; NF copula.

  *③ Experimental Results*\
  #hide[③ ]SOTA fidelity; architecture-agnostic.
]


// #pop.column-box(heading: "Paper Outline")[
//   #import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
//   #set text(24.2pt)
//   #diagram(
//     node-stroke: .08em,
//     node-fill: gradient.radial(lightbg, primary.lighten(70%), center: (30%, 20%), radius: 80%),
//     spacing: 3em,
//     edge-stroke: primary,
//     node((0,0), [*Marginal\ Modeling*], inset: 1em),
//     edge("-|>"),
//     node((1,0), [*Dependence\ Modeling*], inset: 1em),
//     edge("-|>"),
//     node((2,0), [*Experimental\ Results*], inset: 1em),
//   )
// ]


// ===================== COLUMN 2 =====================

#pop.column-box(heading: "Marginal Modeling")[
  === Why Statistical Model Selection Fails

  Heavy-tail distributions with similar NLL imply *wildly different moments* --- making data-driven selection unreliable.

  // #v(0.2em)
  // #text(size: 23pt)[
  //   #tlt(
  //     columns: (1fr, auto, auto, auto),
  //     table.header[*Distribution*][*Test NLL*][*Mean ($10^3$)*][*Var ($10^7$)*],
  //     [ZI-SLN],        [$9.2484$], [$4.42$], [$2.04$],
  //     [ZI-GB2],        [$9.2485$], [$4.39$], [$2.02$],
  //     [ZI-GLN],        [$9.2485$], [$4.37$], [$1.90$],
  //     [ZI-TLN],        [$9.2491$], [$4.40$], [$2.06$],
  //     [ZI-Lognormal],  [$9.2495$], [$4.42$], [$2.14$],
  //     [ZI-BurrXII],    [$9.2546$], [$4.47$], [$4.00$],
  //     [ZI-Log-logistic],[$9.2569$],[$4.74$], [$39.5$],
  //     [ZI-Gamma],      [$9.2909$], [$4.38$], [$1.28$],
  //   )
  // ]
  // #text(size: 22pt)[_NLL gap $< 0.005$ yet variance differs by $30times$._]

  #v(-0.2em)
  === Physics-Informed Approach: Axioms & Hypotheses

  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 1 — Discrete Counting:*  $N tilde "Poisson"(lambda Delta t)$, where $N$ is the number of winning impressions, $lambda > 0$ is the instantaneous market intensity, and $Delta t$ is the time window duration.
  ]
  #v(0.06em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 2 — Compound Accumulation:*  $Y = sum_(i=1)^N X_i$, where $Y$ is a macroscopic feedback metric (e.g., Cost, PGMV) and $X_i$ is the microscopic mark (e.g., market price or estimated value) of the $i$-th won impression.
  ]
  #v(0.06em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 3 — Shared Event:*  Cost $C$ and Value $V$ are coupled via the shared latent intensity $lambda$ through a nested hierarchy: $V = sum_(i=1)^(N_"PV") v_i$ and $C = sum_(j=1)^(N_"clk") c_j$, where $N_"clk" tilde "Binomial"(N_"PV", p_"ctr")$.
  ]
  #v(0.06em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 4 — Dual Zero-Inflation:*  Structural zeros: $P(Y=0|lambda) = e^(-lambda Delta t)$ (no auctions won); Anomalous zeros: gate $G tilde "Bernoulli"(1-epsilon)$, where $epsilon$ is the latent channel failure rate.
  ]
  #v(0.15em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Hypothesis 1:* $ln lambda tilde cal(N)(mu, sigma^2)$, where $lambda$ is the market intensity, $mu$ is the log-mean, and $sigma^2$ is the log-variance (multiplicative heterogeneity).
  ]
  #v(0.06em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Hypothesis 2:* $X_i tilde "Gamma"(alpha, beta)$, where $X_i$ are individual microscopic marks, $alpha$ is the shape parameter, and $beta$ is the rate parameter.
  ]

  // #v(0.2em)
]

#pop.column-box(heading: "Marginal Modeling")[
  === Evidence for Hypothesis 1

  #v(0.4em)

  #figure(caption: [Q-Q plot of latent $ln lambda$ vs.\ standard normal ($R^2 = 0.99942$)])[
    #image("images/fig3_posterior_qq_plot.png", width: 90%)
  ]
  #v(0.3em)

  As shown in the Q–Q plot, points lie on the $y = x$ line with $R^2 = 0.99942$, indicating the log-normal latent-intensity model explains nearly all variability. This strong fit disfavors alternatives (e.g., gamma or inverse-Gaussian) and supports a log-normal multiplicative volatility.

  

  #v(0.6em)

  *Evidence for Hypothesis 2* (Gamma marks): fitting the distribution of individual PGMV marks:

  #v(0.4em)

  #text(size: 28pt)[
    #tlt(
      columns: (1fr, auto, auto, auto),
      table.header[*Model*][*NLL*][*KS Stat*][*AD Stat*],
      [Log-normal],  [$3389.17$], [$0.1129$], [$18.07$],
      [Gumbel],      [$4358.78$], [$0.2265$], [$95.49$],
      [*Gamma*],     [*$3293.00$*], [*$0.0554$*], [*$3.05$*],
    )
  ]
  #[_Gamma decisively outperforms alternatives in Anderson-Darling test._]

  #v(0.6em)
  === Derived Laws & ZI-GB2 Surrogate
  #v(0.4em)

  *Traffic* → ZI-Poisson-Lognormal\
  *Value* → ZI-Tweedie-Lognormal (ZI-TLN)

  Since ZI-TLN lacks a closed form, we use *ZI-GB2* as the practical surrogate:

  #v(0.3em)

  $ P(y) = (1 - pi) delta(y) + pi dot (a y^(a p - 1)) / (b^(a p) B(p,q) [1 + (y\/b)^a]^(p+q)) $

  #v(0.3em)

  where $pi$ is the probability of a non-zero outcome (the Bernoulli gate); $delta(y)$ is the Dirac delta; $a > 0$ regulates power-law decay; $b > 0$ is the scale; $p, q > 0$ govern bulk and tail shape; $B(p,q) = Gamma(p)Gamma(q)\/Gamma(p+q)$ is the Beta function.

  #v(.8em)

  #text(size: 23pt)[
    #tlt(
      columns: (1fr, auto, auto, auto, auto),
      table.header[*Surrogate*][*NLL Gap*][*VaR Err*][*Mean Err*][*Var Err*],
      [ZI-Lognormal], [$0.094$], [$54.3%$], [$41.2%$], [$1725%$],
      [ZI-SLN], [$0.086$], [$30.5%$], [$30.6%$], [$1075%$],
      [*ZI-GB2 (Ours)*], [*$0.047$*], [*$11.5%$*], [*$18.3%$*], [*$36.6%$*],
    )
  ]
  #v(.63em)
]

// ===================== COLUMN 3 =====================

#pop.column-box(heading: "Dependence Modeling: NF Copula")[
  === Perfect Tail Dependence from Physics

  *Proposition* (Asymptotic Tail Dependence): Under the axioms and hypotheses,
  $ lim_(u arrow 1^-) P(F_C (C) > u | F_V (V) > u) = 1 $
  where $F_C$ and $F_V$ are the CDFs of Cost $C$ and Value $V$ respectively, and $u$ is the tail threshold. Cost and Value are *perfectly tail-dependent*.

  #v(0.2em)

  === Normalizing Flow Copula

  #v(10pt)

  #figure(caption: [Conditional tail probability $P(U_("PGMV") > u | U_("PV") > u)$ (where $U = F(dot)$ denotes the probability integral transform) vs.\ tail threshold $(1-u)$. Real data maintains high co-extreme dependence as $u arrow 1$; the NF copula tracks this faithfully, while the Gaussian copula incorrectly decays to independence.])[
    #image("images/fig4_tail_dependence_cond_prob.png", width: 90%)
  ]

  #v(12pt)

  #text(size: 25.3pt)[
    #tlt(
      columns: (auto, auto, auto, auto, auto),
      table.header[*Copula*][*Gaussian*][*Student-t*][*Gumbel*][*NF (Ours)*],
      [*Test NLL*], [$-1.405$], [$-1.441$], [$-0.540$], [*$-1.909$*],
    )
  ]
  #[_NF copula achieves best NLL and correctly captures tail dependence._]

  #v(7pt)
]

#pop.column-box(heading: "Main Results: Distributional Fidelity")[
  #v(10pt)
  #text(size: 22pt)[
    #show table.cell.where(y: 0): set text(.7em)
    #tlt(
      columns: (160pt, auto, auto, auto, auto, auto, auto, auto, auto),
      table.header[#text(1.3em)[*Method*]][*CLICK\ SMAPE*][*CLICK\ CRPS*][*COST\ SMAPE*][*COST\ CRPS*][*PV\ SMAPE*][*PV\ CRPS*][*VALUE\ SMAPE*][*VALUE\ CRPS*],
      [BFM (MSE)],    [1.763], [1.417], [1.680], [0.860], [1.974], [50.46], [1.756], [8.231],
      [BFM (GB2)],    [0.685], [0.688], [0.775], [0.605], [0.479], [12.13], [0.738], [3.434],
      [Inf. (MSE)],   [1.226], [0.473], [1.358], [0.660], [0.388], [14.80], [0.567], [3.670],
      [Inf. (SLN)],   [*0.188*], [*0.381*], [*0.266*], [0.330], [0.377], [14.20], [0.348], [2.586],
      [Inf. (GB2)],   [0.352], [0.638], [0.269], [*0.316*], [*0.314*], [*8.81*], [*0.342*], [*2.091*],
      [Trans. (MSE)], [1.432], [0.944], [1.635], [0.787], [0.476], [16.66], [0.808], [4.606],
      [Trans. (GB2)], [0.706], [0.734], [0.772], [0.603], [0.471], [12.16], [0.733], [3.445],
    )
  ]
  #v(15pt)

  *Key insights:*
  
  - *MSE* yields the worst performance across *all* architectures, confirming log-MSE regression is ill-suited for RTB
  - *ZI-GB2* leads on PV and Value metrics (PV CRPS: $14.80 arrow 8.81$, Value CRPS: $3.670 arrow 2.091$)
  - Physics-informed loss is *architecture-agnostic*: consistent gains on BFM, Informer, and Transformer backbones

  #v(8pt)
]

// #pop.column-box(heading: "Conclusions")[
//   + *Motivation:* Log-MSE regression fails to model zero-inflation, heteroscedasticity, heavy tails, and tail dependence — and cannot even estimate the mean correctly.
//   + *Marginal:* Statistical model selection fails in heavy-tail regimes; physics-informed derivation from axioms yields ZI-PLN and ZI-TLN laws; *ZI-GB2* is the efficient surrogate.
//   + *Dependence:* Shared winning impressions imply $lambda_u = 1$; *NF copula* captures this where Gaussian copula ($lambda_u = 0$) fails.
//   + *Results:* SOTA distributional fidelity; $alpha_("GB2") approx 0.16 > alpha_("MSE") approx 0.12$ — physics-informed models scale better.
// ]

])
