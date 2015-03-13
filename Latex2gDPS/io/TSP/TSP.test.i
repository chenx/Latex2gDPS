\begin{declaration}
$ModuleType$ : TSP
$ModuleName$ : TSP
$Dimension$ : 
  c = { 0, 1, 8, 9, 60; 2, 0, 12, 3, 50; 7, 11, 0, 6, 14;
      10, 4, 5, 0, 15; 61, 51, 13, 16, 0 }
$Alias$ : v = currentNode, S = nodesVisited, d = alpha, c = distance
\end{declaration}

\begin{equation}
\label{TSP_DPFE1}
f(v,S)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d \notin S} \{ f(d,S \cup \{d\}) +c_{v,d} \} }
                                                     & \mbox{if $|S|<n$} \\
   c_{v,s}                                           & \mbox{if $|S|=n$}\\
\end{array}
\right.
\end{equation}
