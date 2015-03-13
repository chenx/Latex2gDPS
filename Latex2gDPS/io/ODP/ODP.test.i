\begin{declaration}
$ModuleType$ : ODP
$ModuleName$ : OptimalDistributionProblem
$Dimension$ : 
  c_{0} = {0, 1, 2, 3},
  c_{1} = {0, 1, 2, 3, 4},
  c_{2} = {0, 3, 4},
  y_{0} = {0, 4, 12, 21},
  y_{1} = {0, 6, 11, 16, 20},
  y_{2} = {0, 16, 22}
$ModuleGoal$ : f(0, 0)
$ModuleBase$ :
  f(3, x) = infty if (x < 6);
  f(3, x) = 0 if (x \ge 6)
\end{declaration}

\begin{equation}
f(i,x)=\min_{a_{i}} \{ y_{i}(a_{i}) + f(i+1,x+c_{i}(a_{i}))\}.
\end{equation}
