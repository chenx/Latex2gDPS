    private static int matchingCharactersAndPruneBoth(int xIndex, 
                                                      int yIndex, int d) {
      if((d==12) &&  //d=12 means decision is to prune both
         (x.charAt(xIndex-1)==y.charAt(yIndex-1))) { 
        return 1;
      }
      return 0;
    }
    private static int xAdjustment(int d) {
      if(d==2) {
        return 0;
      }
      return 1;
    }
    private static int yAdjustment(int d) {
      if(d==1) {
        return 0;
      }
      return 1;
    }
