    private static NodeSet possibleNextNodes(int node) {
      NodeSet result = new NodeSet();
      for (int i=0; i<distance[node].length; i++) {
        if (distance[node][i]!=infty) {
          result.add(new Integer(i));
        }
      }
      return result;
    }
