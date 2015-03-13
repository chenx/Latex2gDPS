\begin{declaration}
$ModuleType$ : ILP
$ModuleName$ : Integer_Linear_Programming
$ModuleGoal$ : f(0, {})
$Dimension$ : 
  c = {3, 5}
$DataType$ : Set S
\end{declaration}

\begin{equation}
f(j,S)=
\left\{
\begin{array}{ll}
  {\displaystyle \max_{x_{j+1} \in D} \{ c_{j+1}x_{j+1} + f(j+1,S \cup \{(j+1,x_{j+1})\}) \} }
                                                     & \mbox{if $j<n$} \\
   0                                                 & \mbox{if $j=n$.}\\
\end{array}
\right.
\end{equation}

