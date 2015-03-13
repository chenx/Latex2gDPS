    private static NodeSet calculateDecisionSet(int stage, 
                                                int y1, int y2, int y3) {
      NodeSet result = new NodeSet();
      //maxPossibleChoiceBecauseOfResourceiRestriction, i=1,2,3
      int mpc1=infty;
      int mpc2=infty;
      int mpc3=infty;
      if(a[0][stage]!=0){
        mpc1=y1/a[0][stage];
      }
      if(a[1][stage]!=0){
        mpc2=y2/a[1][stage];
      }
      if(a[2][stage]!=0){ 
        mpc3=y3/a[2][stage];
      }
      for (int i=0; i<=Math.min(mpc1,Math.min(mpc2,mpc3)); i++) {
        result.add(new Integer(i));
      }
      return result;
    }
