\begin{declaration}
$ModuleType$ : COV
$ModuleName$ : COV_Optimal_Covering_Problem
$Dimension$ : c = {1, 4, 5, 7, 8, 12, 13, 18, 19, 21},
              v = 9
$ModuleGoal$ : f(3, 10 - 1) 
\end{declaration}

\begin{equation}
f(j,l)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d \in \{j-2,\ldots,l-1\}}
    \{ (l-d)c_{l} + f(j-1,d) \} } & \mbox{if $j>1$}\\
                       (l+1)c_{l} & \mbox{if $j=1$.}\\
\end{array}
\right.
\end{equation}

