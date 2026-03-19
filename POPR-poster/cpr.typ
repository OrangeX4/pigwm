 #import "peace-of-posters/lib.typ": *
#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

#set page("a0", margin: 1cm)
#set-poster-layout(layout-a0)
#set text(font: "Arial", size: layout-a0.at("body-size"))

#let box-spacing = 1.2em
#set columns(gutter: box-spacing)
#set block(spacing: box-spacing)
#update-poster-layout(spacing: box-spacing)

#set-theme(nju)
#set par(justify: true)
#let uni-dark-blue = rgb("#1dabfc")


#title-box(
  [Parallel-in-Time Variational Inference for Latent\ Stochastic Differential Equations],
  authors: "Chenyang Wu, Pengfei Liu, Zongzhang Zhang*, Yang Yu",
  // institutes: [
  //   National Key Laboratory for Novel Software Technology, Nanjing University, China \
  //   School of Artificial Intelligence, Nanjing University, China
  // ],
  image: stack(
  grid(
    columns: (1fr, 0.4fr),
    column-gutter: 1cm,
    align(left, image("base/lamda_logo.png", height: 8cm)),
    align(left, image("base/nju_color_logo.png", height: 8cm)),
  )
),
  // subscript: "*indicates the corresponding author"
)

#column-box(
  heading: [Schematic Comparison of Neural SDE Training Frameworks],
)[
  #align(center)[
    #image("images/pipeline.png", width: 95%)
  ]
]
#columns(2, [
  // #column-box(
  // heading: [About This Work],
  // )[
  //   Latent stochastic differential equations (SDEs) naturally model continuous-time, irregularly-sampled dynamics, but variational training is often bottlenecked by *sequential posterior sampling* and *difficult temporal credit assignment*.\
  
  //   We propose *Parallel-in-Time Variational Inference (PiTVI)*, a framework that:
  //   - models the variational posterior as a *non-Markovian operator* over the full noise history,
  //   - uses a *causal Transformer* for *global temporal credit assignment*,
  //   - supports *non-Markovian Gaussian Volterra noise* and enables *parallel-in-time posterior sampling* with *O(log L)* temporal complexity.
  // ]

  // #column-box(
  //   heading: [Motivation],
  // )[
  //   == Why existing Neural SDE inference is unsatisfactory

  //   - *Sequential adjoint / solver-based VI*: posterior inference follows a Markovian recurrence and depends on sequential numerical integration, resulting in slow sampling and BPTT-style optimization difficulties.
  //   - *Solver-free marginal matching*: training can be cheap, but the posterior is only locally constrained, often missing long-range temporal consistency and still requiring *sequential* trajectory generation at inference time.
  //   - *Non-Markovian and multiplicative noise*: fractional / Volterra noise and state-dependent diffusion make advanced solvers even harder to parallelize directly.

  // ]

    #column-box(
    heading: [Background & Motivation],
  )[
    Latent stochastic differential equations (SDEs) provide a natural framework for continuous-time, irregularly-sampled dynamics, but variational inference is often limited by *sequential posterior sampling* and weak *long-range temporal credit assignment*. Existing solver-based methods simulate the posterior step by step, making training slow and difficult to optimize, while solver-free matching methods often only enforce local consistency and still require sequential rollout at inference time.

    To address this, we propose *Parallel-in-Time Variational Inference (PiTVI)*. The key idea is to replace the usual Markovian, step-by-step posterior solver with a *non-Markovian operator* that maps the full noise history and observations directly to the latent trajectory. This enables *global temporal reasoning* with a causal Transformer and makes posterior trajectory sampling *parallel in time* with *O(log L)* span complexity.
  ]
  
  #column-box(
    heading: [Our Solution],
  )[
    PiTVI replaces *sequential posterior simulation* with a *parallel-in-time variational operator*. Let $D$ denote the observations, $W$ the driving noise history, $Z$ the latent trajectory, and $f$ the posterior drift. The variational posterior is written as
    $ (Z, f) = F_phi(W, D), $
    where $F_phi$ is a neural operator parameterized by $phi$.

    After discretizing time on a grid ${t_j}_(j=0)^L$, with latent states ${z_j}$ and noise increments ${Delta W_j}$, the discrete posterior becomes
    $ ({z_j}_(j=1)^L, {f_j}_(j=0)^L) = T_phi(z_0, {Delta W_j}_(j=0)^L, D). $
    Here, $z_0$ is the initial latent state, $f_j$ is the posterior drift on interval $j$, and $T_phi$ is a causal sequence model that outputs the whole latent path.

    == Parallel computation graph
    PiTVI implements $T_phi$ with a three-stage parallel pipeline:

    - *Stage 1: Observation amortization.*  
      An encoder compresses sparse observations into a context vector
      $ c = "Encoder"_phi(D), $
      which summarizes the information in $D$.

    - *Stage 2: Parallel coefficient generation.*  
      A *causal Transformer* reads the initial state $z_0$, past noise increments, and the observation context $c$, then predicts the coefficients used for each time interval:
      $ C_j = "Transformer"_phi(z_0, {Delta W_k}_(k < j), c). $
      Causality ensures that interval $j$ only depends on past noise and observations, so the posterior remains non-anticipating.

    - *Stage 3: Path reconstruction.*  
      The predicted coefficients are converted into latent increments
      $ Delta z_j = "UpdateRule"(C_j, C_(j+1), Delta W_j, t_j, Delta t_j), $
      and the full trajectory is reconstructed by cumulative summation:
      $ z_k = z_0 + ("cumsum"(Delta Z))_k. $
      Since prefix-sum is associative, posterior trajectory sampling is *parallel in time* with *O(log L)* span complexity.

    == Main idea in practice
    PiTVI also extends beyond the simplest additive-noise setting. For state-dependent or more complex diffusion processes, it predicts the coefficients required by the chosen numerical scheme and trains them with a scheme-consistent objective, so explicit, predictor--corrector, and implicit-style updates can all be handled within the same framework.
  ]

  // #column-box(
  //   heading: [Our Solution],
  // )[
  //   PiTVI replaces *sequential posterior simulation* with a *parallel-in-time variational operator*. Instead of parameterizing the posterior by a state-by-state Markovian solver, it directly maps the *driving noise history* and observations to the latent trajectory and posterior drift:$(Z, f) = F_phi (W, D).$
  //   After discretizing time on a grid ${t_j}_(j=0)^L$, the discrete posterior is written as:$ ({z_j}_(j=1)^L, {f_j}_(j=0)^L) = T_phi (z_0, {Delta W_j}_(j=0)^L, D). $

  //   == Parallel computation graph
  //   The operator $T_phi$ is implemented by a three-stage parallel pipeline:
  
  //   - *Stage 1: Observation amortization.* An encoder summarizes sparse observations into a context vector $c = "Encoder"_phi (D)$.
  //   - *Stage 2: Parallel coefficient generation.* A *causal Transformer* reads $z_0$, past noise increments, and $c$, then predicts the coefficients for each interval:
  //     $ C_j = "Transformer"_phi (z_0, {Delta W_k}_(k < j), c). $
  //     Causality ensures the posterior remains non-anticipating.
  //   - *Stage 3: Path reconstruction.* The model converts coefficients into increments:$ Delta z_j = "UpdateRule"(C_j, C_(j+1), Delta W_j, t_j, Delta t_j), $then reconstructs the full path with a *parallel prefix scan*:$ z_k = z_0 + ("cumsum"(Delta Z))_k. $
  //   Because prefix-sum is associative, posterior trajectory sampling becomes *parallelizable in time* with span complexity *O(log L)*.

  //   == Additive-noise case
  //   For state-independent diffusion, PiTVI predicts only the posterior drift:
  //   $ C_j = {f_j}, quad
  //   Delta z_j = f_j Delta t_j + g(t_j) Delta W_j. $
    
  //   The Transformer outputs $f_j$, and the latent path is reconstructed by parallel scan.
    
  //   == Multiplicative-noise case
  //   For state-dependent diffusion $g_theta (z_t, t)$, direct evaluation is sequential because it depends on the unknown trajectory. PiTVI avoids this by predicting auxiliary diffusion coefficients $hat(G) = {hat(g)_j}_(j=0)^(L-1)$ together with the posterior drift. These coefficients are constrained to stay consistent with the prior diffusion along the generated path.
    
  //   To enforce this, PiTVI defines a scheme-dependent consistency loss:
  //   $ C(phi) = E_(q_phi(Z, f | D)) [1 / L sum_(j=0)^(L-1) ell_"scheme"(hat(G)_j, Z)], $
  //   where $ell_"scheme"$ measures mismatch between predicted and prior diffusion terms under the chosen solver. The relaxed constraint $C(phi) <= epsilon$ is optimized with the augmented Lagrangian:
  //   $ L_"total" = -L_"ELBO" + lambda (C(phi) - epsilon) + (mu / 2) C(phi)^2. $
    
  //   This converts the sequential algebraic constraints of multiplicative-noise solvers into a trainable *parallel optimization objective*.

  //   == Numerical schemes supported by PiTVI
  //   - *Multiplicative Euler--Maruyama*: uses predicted drift and diffusion coefficients in the simplest explicit update.  
  //   - *Stochastic Heun*: adds a predictor--corrector step for improved approximation accuracy.  
  //   - *Stochastic Crank--Nicolson*: uses an implicit-style discretization and is the main PiTVI variant reported in the paper.

  // ]
  #column-box(
    heading: [Experiments],
  )[
  
    == (1) Stochastic Lorenz Attractor
    On Lorenz, PiTVI achieves much lower NELBO and reconstruction error than Latent SDE and SDE Matching, while reducing posterior sampling time to about $7.28$ ms. The table below also shows PiTVI (CN) attains the best KL ($0.04$).
  
    #figure(
      stack(
        dir: ltr,
        box([#image("images/results_1.png")], width: 100%),
      )
    )
  
    == (2) Sparse Lorenz with Known Prior
    Under sparse observations, PiTVI gives the best inference accuracy, reaching $1.49$ NELBO and $2.16$ reconstruction MSE. The figure below further shows more coherent interpolation across large temporal gaps.
  
  
    #figure(
      stack(
        dir: ltr,
        box([#image("images/results_2.png")], width: 80%),
      )
    )
  
    == (3) Stochastic Moving MNIST
    On high-dimensional stochastic video, PiTVI remains competitive with specialized sequence models. On Stochastic Moving MNIST, it achieves the best reconstruction PSNR (*24.45*), while also obtaining competitive Static / Dynamics FD (*1.79* / *0.64*). These results show that PiTVI scales effectively to stochastic visual sequence modeling on Moving MNIST.
  ]
])

