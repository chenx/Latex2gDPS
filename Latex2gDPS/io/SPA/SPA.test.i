\begin{declaration}
$ModuleType$ : SPA
$ModuleName$ : SPA
$Dimension$ :
  c = {infty, 3, 5, infty; infty, infty, 1, 8;
       infty, infty, infty, 5; infty, infty, infty, infty}
$ModuleGoal$ : f(0)
\end{declaration}

\begin{equation}
\label{SPA_DPFE}
f(x)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d \in V} 
    \{ f(d)+c_{x,d} \} } & \mbox{if $x<n-1$}\\
                       0 & \mbox{if $x=n-1$.}\\
\end{array}
\right.
\end{equation}

