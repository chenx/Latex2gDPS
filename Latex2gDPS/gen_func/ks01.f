    private static NodeSet calculateDecisionSet(int objInd, int w) {
      NodeSet decSet = new NodeSet();
      decSet.add(new Integer(0)); //decision to not take object 
                                  //is always feasible
      if(w>=weight[objInd]) { //check if there is enough space to take object
        decSet.add(new Integer(1));
      }
      return decSet;
    }
