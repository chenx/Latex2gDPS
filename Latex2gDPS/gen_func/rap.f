    //calculate probability that all xn items produced are defect
    //private static double probabilityThatAllDefect(int xn) {
    //  return Math.pow(defectProbability,xn); 
    //}
    private static double PNFUNC_power_dbl(double base, int index) {
      return Math.pow(base, index);
    }
    //function K calculates the setup cost
    private static double K(int xn) {
      if (xn==0) {  //if nothing is produced
        return 0;   //there is no setup cost
      }
      //otherwise we encounter a fix setup cost of $300
      return setupCost;
    }
