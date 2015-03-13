    private static double sumDbl(SortedSet items) {
      double result=0.0;
      for (int i=((Integer) items.first()).intValue();
           i<=((Integer) items.last()).intValue();
           i++) {
        result+=probability[i];
      } 
      return result;
    }
    private static NodeSet setLT(NodeSet items, int pivot) {
      // Set of items less than pivot.
      // headSet() DOES NOT include pivot
      return new NodeSet(items.headSet(new Integer(pivot)));
    }
    private static NodeSet setGT(NodeSet items, int pivot) {
      // Set of items greater than pivot.
      // DOES NOT include pivot.
      return new NodeSet(items.tailSet(new Integer(pivot + 1)));
    }
