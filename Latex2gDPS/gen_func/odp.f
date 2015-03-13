    //create the index set of possible alternatives
    //which may vary from stage to stage
    private static NodeSet possibleAlternatives(int stage) {
      NodeSet result = new NodeSet();
      for (int i=0; i<cashFlow[stage].length; i++) {
        result.add(new Integer(i));
      }
      return result;
    }
