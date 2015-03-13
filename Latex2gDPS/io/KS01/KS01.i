\begin{declaration}
$ModuleType$ : KS01
$ModuleName$ : KS01_v1
$ModuleGoal$ : f(n - 1, c)
$DataType$ : double c
$Dimension$ :
  v = {25, 24, 15},
  w = {18, 15, 10},
  c = 22,
  n = 3
\end{declaration}

\begin{equation}
\label{KS01_DPFEv1}
f(i,w)=
\left\{
\begin{array}{ll}
  0         & \mbox{if $i=-1$ and $0 \le w \le c$}\\
  -\infty   & \mbox{if $i=-1$ and $w<0$}\\
  {\displaystyle \max_{x_{i} \in \{0,1\}} \{x_{i}v_{i}+f(i-1,w-x_{i}w_{i})\} }
       & \mbox{if $i \ge 0$}.\\
\end{array}
\right.
\end{equation}

