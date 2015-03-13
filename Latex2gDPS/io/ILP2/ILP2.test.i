\begin{declaration}
$ModuleType$ : ILP
$ModuleName$ : Integer_Linear_Programming
$ModuleGoal$ : f(0, {})
$Dimension$ :
  c = {3, 5}
$DataType$ : Set S
\end{declaration}

\begin{equation}
\label{ILP_DPFEv2}
f(j,y_{1},\ldots,y_{m}) \\
= \left\{
  \begin{array}{ll}
    {\displaystyle \max_{x_{j+1} \in D} \{ c_{j+1}x_{j+1} 
     \quad + f(j+1,y_{1}-a_{1,j+1}x_{j+1},\ldots,y_{m}-a_{m,j+1}x_{j+1}) \} }
                                                       & \mbox{if $j<n$} \\
     0                                                 & \mbox{if $j=n$.}\\
  \end{array}
\right.
\end{equation}

