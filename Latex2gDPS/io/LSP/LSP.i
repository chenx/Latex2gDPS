\begin{declaration}
$ModuleType$ : LSP
$ModuleName$ : LSP_Longest_Simple_Path_Problem
$ModuleGoal$ : f({S}, S)
$Dimension$ : c = {
  -infty, 1, -infy, 1;
  1, -infty, 1, -infty;
  -infty, 1, -infty, 1;
  1, -infty, 1, -infty
  }
\end{declaration}

\begin{equation}
\label{LSP}
f(S,v)=
\left\{
\begin{array}{ll}
  {\displaystyle \max_{d \notin S} \{ f(S \cup \{d\}, d) +c_{v,d} \} }
                                                      & \mbox{if $v \ne t$} \\
   0                                                  & \mbox{if $v = t$}\\
\end{array}
\right.
\end{equation}
