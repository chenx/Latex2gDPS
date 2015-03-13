\begin{declaration}
$ModuleType$ : MCM
$ModuleName$ : MultipleChainMultiplication
$Dimension$ : d = {3, 4, 5, 2, 2}
$Alias$ : i = firstIndex, j = secondIndex, d = dimension
\end{declaration}

\begin{equation}
f(i,j)=
\left\{
\begin{array}{ll} 
  {\displaystyle \min_{k \in \{ i, \ldots, j-1\}} 
    \{ f(i,k)+f(k+1,j)+d_{i-1}d_{k}d_{j} \} } & \mbox{if $i<j$}\\
                                            0 & \mbox{if $i=j$.}\\
\end{array}
\right.
\end{equation}
