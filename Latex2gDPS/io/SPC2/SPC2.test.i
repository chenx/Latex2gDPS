\begin{declaration}
$ModuleType$ : SPC
$ModuleName$ : SPC2
$ModuleGoal$ : f(0, {0})
\end{declaration}

\begin{equation}
\label{spcAlt_DPFE}
f(x,S)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d \notin S} \{ f(d,S \cup \{d\}) +c_{x,d} \} } 
                                                     & \mbox{if $x<n-1$} \\
   0                                                 & \mbox{if $x=n-1$.}\\
\end{array}
\right.
\end{equation}

