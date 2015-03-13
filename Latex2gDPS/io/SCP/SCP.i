\begin{declaration}
$ModuleType$ : SCP
$ModuleName$ : SCP_Stagecoach_Problem
$ModuleGoal$ : f(0, 0)
$Dimension$ : c = {
  infty, 550, 900, 770, infty, infty, infty, infty, infty, infty;
  infty, infty, infty, infty, 680, 790, 1050, infty, infty, infty;
  infty, infty, infty, infty, 580, 760, 660, infty, infty, infty;
  infty, infty, infty, infty, 510, 700, 830, infty, infty, infty;
  infty, infty, infty, infty, infty, infty, infty, 610, 790, infty;
  infty, infty, infty, infty, infty, infty, infty, 540, 940, infty;
  infty, infty, infty, infty, infty, infty, infty, 790, 270, infty;
  infty, infty, infty, infty, infty, infty, infty, infty, infty, 1030;
  infty, infty, infty, infty, infty, infty, infty, infty, infty, 1390;
  infty, infty, infty, infty, infty, infty, infty, infty, infty, infty
  }
\end{declaration}

\begin{equation}
\label{SCP_DPFE}
f(g,x)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d \in V_{g+1}} 
    \{ f(g+1,d)+c_{x,d} \} } & \mbox{if $x<n-1$}\\
                           0 & \mbox{if $x=n-1$.}\\
\end{array}
\right.
\end{equation}

