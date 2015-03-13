\begin{declaration}
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
