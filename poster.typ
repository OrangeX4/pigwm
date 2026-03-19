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
    "heading-size":     40pt,
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
  text-relative-width: 70%,
  spacing: 0pt,
  title-size: 62pt,
  subtitle-size: 46pt,
  authors-size: 33pt,
  institutes-size: 31pt,
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

// ============================================================================
// 3-Column Layout
// ============================================================================
#columns(3, [

// ===================== COLUMN 1 =====================

#pop.column-box(heading: "Paper Outline")[
  *① Problem Setup:* RTB bidding is formulated as a history-dependent Markov decision process (HMDP). The key task is learning the conditional joint density $P_theta (bold(y)_t | h_t, bold(b)_t, bold(c))$ of multi-dimensional feedback (clicks, cost, GMV) from an offline dataset.

  *② Physics-Informed Marginal Modeling:* Starting from four first-principle axioms about the auction mechanism, we derive that traffic follows a ZI-Poisson-Lognormal law and cumulative value follows a ZI-Tweedie-Lognormal law. We then select ZI-GB2 as an efficient closed-form surrogate that matches the true distribution.

  *③ Copula Dependence:* We prove that Cost and Value are asymptotically tail-dependent ($lambda_u = 1$) due to their shared winning-impression process. A normalizing flow (NF) copula is used to capture this full dependency structure, while standard Gaussian copulas incorrectly imply tail independence ($lambda_u = 0$).

  *④ Empirical Validation:* On large-scale production datasets from Taobao, our model achieves state-of-the-art distributional fidelity across all metrics and exhibits clear neural scaling laws, confirming that physics-informed statistical alignment is a prerequisite for high-fidelity world models.
]

#pop.column-box(heading: "Motivation & Problem")[
  Current RTB simulators rely on *deterministic point predictions* (MSE), which are ill-posed for auction data:

  #block(inset: (left: 0.5em))[
    *①* Cannot capture *extreme heteroscedasticity* (variance $prop mu^p$)\
    *②* Neglect *structural coupling* between Cost and GMV\
    *③* Log-MSE introduces *systematic bias* via Jensen's inequality ($EE[log Y] != log EE[Y]$)
  ]

  *Our goal:* Estimate the full conditional joint density
  $P_theta (bold(y)_t | h_t, bold(b)_t, bold(c))$
  that respects *zero-inflation*, *heavy tails*, and *tail dependence*.

  A high-fidelity generative world model is indispensable for offline RL policy training, since deploying RL directly online incurs prohibitive exploration costs.
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

  *Hypotheses:* $ln lambda tilde cal(N)(mu, sigma^2)$ (multiplicative heterogeneity) and $X_i tilde "Gamma"(alpha, beta)$ (gamma marks). These are empirically verified via Q-Q plots and Hill estimators on production data.
]

#pop.column-box(heading: "Key Notation")[
  #set text(size: 26pt)
  #table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 0.4em, y: 0.3em),
    align: (right, left),
    table.hline(stroke: 0.8pt),
    table.header([*Symbol*], [*Description*]),
    table.hline(stroke: 0.5pt),
    [$bold(y)_t$],     [Multi-dimensional feedback vector (clicks, cost, GMV)],
    [$h_t$],           [Interaction history up to time $t$],
    [$bold(b)_t$],     [Bidding control vector (action)],
    [$bold(c)$],       [Static campaign covariates],
    [$N$],             [Number of winning impressions in a slot],
    [$X_i$],           [Per-impression value (microscopic mark)],
    [$Y = sum X_i$],   [Cumulative feedback aggregated over $N$ impressions],
    [$lambda$],        [Poisson intensity (latent market activity rate)],
    [$pi$],            [Zero-inflation probability (structural zeros)],
    [$mu, sigma^2$],   [Mean and variance of $ln lambda$ (lognormal heterogeneity)],
    [$alpha, beta$],   [Gamma shape and rate parameters of mark $X_i$],
    [$a,p,q,b$],       [ZI-GB2 distribution shape and scale parameters],
    [$lambda_u$],      [Upper tail dependence coefficient between Cost and Value],
    table.hline(stroke: 0.8pt),
  )
]

#pop.column-box(heading: "Derived Laws & ZI-GB2 Surrogate")[
  From the axioms and hypotheses, the marginal distributions are derived as:

  *Traffic* → *ZI-Poisson-Lognormal* \
  *Value* → *ZI-Tweedie-Lognormal* (physical ground truth)

  Since ZI-TLN lacks a closed-form density, we propose *ZI-GB2* as a tractable surrogate:
  $ P(y) = (1 - pi) delta(y) + pi dot (a y^(a p - 1)) / (b^(a p) B(p,q) [1 + (y\/b)^a]^(p+q)) $

  ZI-GB2 subsumes ZI-Lognormal, ZI-Pareto, and ZI-Weibull as special cases, giving it the flexibility to match the true heavy-tailed shape.

  #v(0.15em)
  #text(size: 25pt)[
    #tlt(
      columns: (220pt, auto, auto, auto, auto),
      table.header[*Surrogate*][*NLL Gap*][*VaR Err*][*Mean Err*][*Var Err*],
      [ZI-Lognormal], [$0.094$], [$54.3%$], [$41.2%$], [$1725%$],
      [ZI-SLN], [$0.086$], [$30.5%$], [$30.6%$], [$1075%$],
      [*ZI-GB2 (Ours)*], [*$0.047$*], [*$11.5%$*], [*$18.3%$*], [*$36.6%$*],
    )
  ]
]


#pop.column-box(heading: "Normalizing Flow Copula")[
  Standard Gaussian copula implies $lambda_u = 0$ (asymptotic tail independence) — a fundamental misspecification for RTB, where extreme events co-occur structurally.

  *Proposition:* Under our axioms, $lim_(u arrow 1^-) P(F_C(C) > u | F_V(V) > u) = 1$

  This means Cost and Value are *perfectly tail-dependent* in the limit, driven by the shared latent intensity $lambda$. We use a *NF copula* with rational quadratic spline flows to capture the full nonlinear dependence.

  #text(size: 25pt)[
    #tlt(
      columns: (auto, auto, auto, auto, auto),
      table.header[*Copula*][*Gaussian*][*Student-t*][*Gumbel*][*NF (Ours)*],
      [*Test NLL*], [$-1.405$], [$-1.441$], [$-0.540$], [*$-1.909$*],
    )
  ]
]

// ===================== COLUMN 2 =====================

#pop.column-box(heading: "Empirical Verification")[
  *Log-normal latent intensity:* The posterior $ln hat(lambda)$ estimated from data fits a standard normal almost perfectly ($R^2 = 0.99942$), strongly validating the log-normal hypothesis.
  #figure(caption: [Q-Q plot of latent $ln lambda$ vs. standard normal. $R^2 = 0.99942$.])[
    #image("images/fig3_posterior_qq_plot.png", width: 60%)
  ]
  *Asymptotic tail dependence:* The NF copula captures the persistent structural coupling between Cost and Value at extreme quantiles, while the Gaussian copula erroneously decays to independence.
  #figure(caption: [Conditional tail probability $P(F_C > u | F_V > u)$ vs. threshold $u$.])[
    #image("images/fig4_tail_dependence_cond_prob.png", width: 66%)
  ]
]


#pop.column-box(heading: "Heavy-Tail Evidence")[
  RTB feedback is not merely skewed — it is *structurally heavy-tailed*. The Hill estimator applied to real Taobao data shows that the tail index $xi > 0$ across all feedback types (clicks, cost, GMV), meaning extreme events have non-negligible probability that standard Gaussian or light-tailed models cannot capture.
  #figure(caption: [Hill estimator confirms heavy-tailedness of RTB feedback across all variables. Extreme events are intrinsic to the market, not outliers.])[
    #image("images/fig1_heavy_tail_viz.png", width: 66%)
  ]
]

#pop.column-box(heading: "Convergence Analysis")[
  We verify that the Compound Poisson-Gamma (Tweedie) approximation to Compound Poisson-Beta is valid. As the Poisson intensity $lambda$ increases, the KL divergence between the two aggregate distributions decreases rapidly toward zero, confirming that the Gamma mark approximation is accurate in the high-traffic regime typical of production RTB.
  #figure(caption: [KL divergence between Compound Poisson-Beta and Compound Poisson-Gamma aggregates vs. intensity $lambda$.])[
    #image("images/fig2_tweedie_lambda_convergence.png", width: 66%)
  ]
]

#pop.column-box(heading: "Main Results: Distributional Fidelity")[
  #text(size: 23pt)[
    #show table.cell.where(y: 0): set text(.7em)
    #tlt(
      columns: (170pt, auto, auto, auto, auto, auto, auto, auto, auto),
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
  #figure(caption: [Median SMAPE vs. model parameter count across architectures and loss functions.])[
    #image("images/fig5_median-smape_vs_params.pdf", width: 80%)
  ]

  Performance follows a power-law: $L(M) prop M^(-alpha)$

  $alpha_("GB2") approx 0.16 > alpha_("MSE") approx 0.12$ — physics-informed models gain *more* from scaling than MSE-trained baselines.

  *Statistical alignment with data generation is a prerequisite for unlocking the potential of large foundation models.*
]

#pop.column-box(heading: "Conclusions")[
  + RTB stochasticity is *structurally heavy-tailed and coupled*
  + Derived *Poisson-lognormal* and *Tweedie-lognormal* laws from first principles; *ZI-GB2* as efficient surrogate
  + *NF copula* captures asymptotic tail dependence ($lambda_u = 1$) missed by Gaussian assumptions ($lambda_u = 0$)
  + *SOTA distributional fidelity* and *clear neural scaling laws* on production-scale Taobao datasets
]

])
