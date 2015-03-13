\begin{declaration}
$ModuleType$ : WLV
$ModuleName$ : WLV_Winning_In_Las_Vegas
$ModuleGoal$ : f(1, s_{1})
$Dimension$ :
  p = 1,
  r = 3,
  t = 5
\end{declaration}

\begin{equation}
\label{WLV_WinningInLasVegas}
f(n,s_{n})=
\left\{
\begin{array}{lll}
  {\displaystyle \max_{x_{n} \in \{0,\ldots,s_{n}\} } 
                   \{   (1-p)f(n+1,s_{n}-x_{n})  
                       +p f(n+1,s_{n}+x_{n}) \} } & \mbox{if $n \le R$} \\
   0 &  \mbox{if $n>R$ and $s_{n}<t$}\\
   1 &  \mbox{if $n>R$ and $s_{n} \ge t$}\\
\end{array}
\right.
\end{equation}

