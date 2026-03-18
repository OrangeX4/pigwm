// ============================================================================
// Academic Poster: Physics-Informed Generative World Models for Real-Time Bidding
// KDD 2026 | Typst + peace-of-posters
// ============================================================================
#import "@preview/peace-of-posters:0.5.6" as pop

// --- Page & Layout Setup ---
#set page("a0", margin: 1cm)
#pop.set-poster-layout(pop.layout-a0)

// --- Custom Minimalist Theme ---
#let primary = rgb("#1a5276")
#let accent  = rgb("#2980b9")
#let lightbg = rgb("#f4f6f7")
#let darkfg  = rgb("#2c3e50")

#pop.set-theme((
  "body-box-args": (
    inset: 0.6em,
    width: 100%,
    stroke: 1.2pt + primary.lighten(60%),
    radius: 6pt,
    fill: white,
  ),
  "body-text-args": (fill: darkfg),
  "heading-box-args": (
    inset: 0.5em,
    width: 100%,
    fill: primary,
    radius: (top: 6pt),
  ),
  "heading-text-args": (fill: white, weight: "bold"),
  "title-box-args": (
    inset: (x: 0.8em, y: 0.5em),
    width: 100%,
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

// ============================================================================
// TITLE
// ============================================================================
#pop.title-box(
  "Physics-Informed Generative World Models for Real-Time Bidding",
  subtitle: "Deriving Statistical Laws from First Principles",
  authors: "Chenyang Wu¹ · Tianyu Wang² · Shengjun Fang¹ · Mingjun Cao¹ · Pengfei Liu¹ · Zongzhang Zhang¹ · Yeshu Li² · Zhilin Zhang² · Chuan Yu² · Jian Xu² · Bo Zheng²",
  institutes: "¹Nanjing University       ²Alibaba Group",
  keywords: "KDD 2026  |  Real-Time Bidding · Generative World Models · Physics-Informed Statistical Modeling · Normalizing Flow Copula",
  text-relative-width: 100%,
  title-size: 62pt,
  subtitle-size: 46pt,
  authors-size: 33pt,
  institutes-size: 31pt,
  keywords-size: 28pt,
)

// ============================================================================
// 3-Column Layout
// ============================================================================
#columns(3, [

// ===================== COLUMN 1 =====================

#pop.column-box(heading: "Motivation & Problem")[
  Current RTB simulators rely on *deterministic point predictions* (MSE), which are ill-posed for auction data:

  #block(inset: (left: 0.5em))[
    *①* Cannot capture *extreme heteroscedasticity* (variance $prop mu^p$)\
    *②* Neglect *structural coupling* between Cost and GMV\
    *③* Log-MSE introduces *systematic bias* via Jensen's inequality
  ]

  *Our goal:* Estimate the full conditional joint density
  $P_theta (bold(y)_t | h_t, bold(b)_t, bold(c))$
  that respects *zero-inflation*, *heavy tails*, and *tail dependence*.
]

#pop.column-box(heading: "Four Fundamental Axioms")[
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 1 — Discrete Counting:*  $N tilde "Poisson"(lambda Delta t)$
  ]
  #v(0.1em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 2 — Compound Accumulation:*  $Y = sum_(i=1)^N X_i$
  ]
  #v(0.1em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 3 — Shared Event:*  Cost & Value coupled via shared $lambda$
  ]
  #v(0.1em)
  #block(fill: lightbg, inset: 0.35em, radius: 4pt, width: 100%)[
    *Axiom 4 — Dual Zero-Inflation:*  Structural ($e^(-lambda Delta t)$) + Anomalous
  ]

  *Hypotheses:* \ $ln lambda tilde cal(N)(mu, sigma^2)$ (multiplicative heterogeneity) and $X_i tilde "Gamma"(alpha, beta)$ (gamma marks).
]


#pop.column-box(heading: "Derived Laws & ZI-GB2 Surrogate")[
  *Traffic* → *ZI-Poisson-Lognormal* \
  *Value* → *ZI-Tweedie-Lognormal* (physical ground truth)

  Since ZI-TLN lacks closed form, we use *ZI-GB2*:
  $ P(y) = (1 - pi) delta(y) + pi dot (a y^(a p - 1)) / (b^(a p) B(p,q) [1 + (y\/b)^a]^(p+q)) $

  #v(0.15em)
  #text(size: 26pt)[
    #table(
      columns: (auto, auto, auto, auto, auto),
      inset: 0.25em,
      stroke: 0.5pt + primary.lighten(50%),
      align: center,
      table.header[*Surrogate*][*NLL Gap*][*VaR Err*][*Mean Err*][*Var Err*],
      [ZI-Lognormal], [$0.094$], [$54.3%$], [$41.2%$], [$1725%$],
      [ZI-SLN], [$0.086$], [$30.5%$], [$30.6%$], [$1075%$],
      [*ZI-GB2 (Ours)*], [*$0.047$*], [*$11.5%$*], [*$18.3%$*], [*$36.6%$*],
    )
  ]
]

#pop.column-box(heading: "Normalizing Flow Copula")[
  Gaussian copula implies $lambda_u = 0$ (tail independence) — wrong for RTB!

  *Proposition:* Under our axioms, $lim_(u arrow 1^-) P(F_C(C) > u | F_V(V) > u) = 1$

  We use *NF copula* with rational quadratic spline flows.

  #text(size: 28pt)[
    #table(
      columns: (auto, auto, auto, auto, auto),
      inset: 0.25em,
      stroke: 0.5pt + primary.lighten(50%),
      align: center,
      table.header[*Copula*][*Gaussian*][*Student-t*][*Gumbel*][*NF (Ours)*],
      [*Test NLL*], [$-1.405$], [$-1.441$], [$-0.540$], [*$-1.909$*],
    )
  ]
]

// ===================== COLUMN 2 =====================
#colbreak()


#pop.column-box(heading: "Empirical Verification")[
  #figure(caption: [Q-Q plot of latent $ln lambda$ vs. standard normal ($R^2 = 0.99942$). Validates log-normal hypothesis.])[
    #image("images/fig3_posterior_qq_plot.png", width: 72%)
  ]
  #v(0.2em)
  #figure(caption: [Tail dependence: NF copula captures persistent structural coupling; Gaussian copula incorrectly decays to independence.])[
    #image("images/fig4_tail_dependence_cond_prob.png", width: 80%)
  ]
]


#pop.column-box(heading: "Heavy-Tail Evidence")[
  #figure(caption: [Hill estimator confirms structural heavy-tailedness of RTB feedback — extreme events are intrinsic to the market.])[
    #image("images/fig1_heavy_tail_viz.png", width: 80%)
  ]
]

#pop.column-box(heading: "Convergence Analysis")[
  #figure(caption: [KL divergence between Compound Poisson-Beta and Compound Poisson-Gamma aggregates decreases rapidly with intensity $lambda$, validating the Gamma mark approximation.])[
    #image("images/fig2_tweedie_lambda_convergence.png", width: 80%)
  ]
]


// ===================== COLUMN 3 =====================
#colbreak()

#pop.column-box(heading: "Main Results: Distributional Fidelity")[
  #text(size: 23pt)[
    #show table.cell.where(y: 0): set text(.7em)
    #table(
      columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
      inset: 1.2em,
      stroke: 0.5pt + primary.lighten(50%),
      align: center,
      table.header[*Method*][*CLICK\ SMAPE*][*CLICK\ CRPS*][*COST\ SMAPE*][*COST\ CRPS*][*PV\ SMAPE*][*PV\ CRPS*][*VALUE\ SMAPE*][*VALUE\ CRPS*],
      [BFM (MSE)], [1.763], [1.417], [1.680], [0.860], [1.974], [50.46], [1.756], [8.231],
      [BFM (GB2)], [0.685], [0.688], [0.775], [0.605], [0.479], [12.13], [0.738], [3.434],
      [Inf. (MSE)], [1.226], [0.473], [1.358], [0.660], [0.388], [14.80], [0.567], [3.670],
      [Inf. (SLN)], [*0.188*], [*0.381*], [*0.266*], [0.330], [0.377], [14.20], [0.348], [2.586],
      [Inf. (GB2)], [0.352], [0.638], [0.269], [*0.316*], [*0.314*], [*8.81*], [*0.342*], [*2.091*],
      [Trans. (MSE)], [1.432], [0.944], [1.635], [0.787], [0.476], [16.66], [0.808], [4.606],
      [Trans. (GB2)], [0.706], [0.734], [0.772], [0.603], [0.471], [12.16], [0.733], [3.445],
    )
  ]

  *Key insights:*
  - MSE yields *poorest* performance across all architectures
  - ZI-GB2 achieves *SOTA* distributional fidelity (PV CRPS: $14.80 arrow 8.81$)
  - Physics-informed loss is *architecture-agnostic* and generalizable
]

#pop.column-box(heading: "Neural Scaling Laws")[
  Performance follows a power-law: $L(M) prop M^(-alpha)$

  $alpha_("GB2") approx 0.16 > alpha_("MSE") approx 0.12$ — physics-informed models gain *more* from scaling.

  *Statistical alignment with data generation is a prerequisite for unlocking the potential of large foundation models.*
]

#pop.column-box(heading: "Conclusions")[
  + RTB stochasticity is *structurally heavy-tailed and coupled*
  + Derived *Poisson-lognormal* and *Tweedie-lognormal* laws from first principles; *ZI-GB2* as efficient surrogate
  + *NF copula* captures asymptotic tail dependence ($lambda_u = 1$) missed by Gaussian assumptions ($lambda_u = 0$)
  + *SOTA distributional fidelity* and *clear neural scaling laws* on production-scale Taobao datasets
]


#pop.column-box(heading: "Selected References")[
  #set text(size: 23pt)
  + Zhang et al. "Feedback control of real-time display advertising." _WSDM_, 2016.
  + He et al. "A unified solution to constrained bidding." _KDD_, 2021.
  + Jorgensen. _The Theory of Dispersion Models._ CRC Press, 1997.
  + McDonald. "Generalized functions for size distribution of income." 2008.
  + Sklar. "Fonctions de répartition à n dimensions et leurs marges." 1959.
  + Durkan et al. "Neural spline flows." _NeurIPS_, 2019.
  + Ji et al. "Bid2X: Dynamics of bidding environment." _KDD_, 2025.
  + Zhou et al. "Informer: Beyond efficient transformer." _AAAI_, 2021.
  + Wiese et al. "Copula & marginal flows." 2019.
  + Resnick. _Heavy-tail phenomena._ Springer, 2007.
]

])

// ============================================================================
// BOTTOM BAR
// ============================================================================
#pop.bottom-box(
  heading-box-args: (
    inset: (x: 0.8em, y: 0.35em),
    width: 100%,
    fill: gradient.linear(primary, accent, angle: 0deg),
    radius: 8pt,
  ),
  heading-text-args: (fill: white),
)[
  #text(size: 28pt)[
    *Contact:* Nanjing University & Alibaba Group
    #h(2em)
    *Conference:* KDD 2026
    #h(2em)
    *Topics:* Real-Time Bidding · Generative World Models · Physics-Informed Statistical Modeling
  ]
]
