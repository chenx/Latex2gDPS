\begin{declaration}
\module_type : TSP
\module_name : TSP
\dimension :
  c = {{0, 1, 8, 9, 60}, {2, 0, 12, 3, 50}, {7, 11, 0, 6, 14},
       {10, 4, 5, 0, 15}, {61, 51, 13, 16, 0}}
\alias : v = currentNode, S = nodesVisited, d = alpha, c = distance
\end{declaration}

\begin{equation}
\label{TSP_DPFE2}
f(v,S)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d \in S} \{ f(d,S - \{d\}) +c_{v,d} \} }
                                                     & \mbox{if $|S|>1$} \\
   c_{v,s}                                           & \mbox{if $S=\emptyset$}\\
\end{array}
\right.
\end{equation}

