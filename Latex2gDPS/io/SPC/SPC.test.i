\begin{declaration}
$ModuleType$ : SPC
$ModuleName$ : SPC
$Dimension$ : 
  c = 
       {infty, 3, 5, infty;
        infty, infty, 1, 8;
        infty, 2, infty, 5;
        infty, infty, infty, infty}
       
$ModuleBase$ : 
  f(x, i) = infty if (x < 3 and i = 0);
  f(x, i) = 0 if x = 3
$Alias$ : x = currentNode, i = nodesVisited, c = distance,
         d = alpha
\end{declaration}

\begin{equation}
\label{spc_DPFE}
f(x,i)=
\left\{
\begin{array}{ll}
  {\displaystyle \min_{d} \{ f(d,i-1) +c_{x,d} \} } 
                                   & \mbox{if $x<n-1$ and $i>0$} \\
   \infty                          & \mbox{if $x<n-1$ and $i=0$}\\
   0                               & \mbox{if $x=n-1$.}\\
\end{array}
\right.
\end{equation}
