class Phone {
  
  
//ArrayList<Integer> dateList = new ArrayList();
IntDict count = new IntDict();
String[] dateRange;
int[] valueRange;
  
  
  void getPubYears (String searchTerm, String facetType) {
  // construct the search object
  TimesArticleSearch mySearch = new TimesArticleSearch();
  // add a search term
  mySearch.addQueries(searchTerm);
  // add a facet type
  mySearch.addFacets(facetType);
  // Do the actual search, which returns a TimesArticleSearchResult
  TimesArticleSearchResult myResult = mySearch.doSearch();
  println(searchTerm + ":   " + myResult.total);
  // Retreive the facet object
  TimesFacetObject[] pubYears = myResult.getFacetList(facetType);
  
  //add to an intDict
  for (TimesFacetObject p:pubYears) {
    count.set(p.term, p.count);
  }
  // sort things and then parcel them out to separate arrays
  count.sortKeys();
  dateRange = count.keyArray();
  valueRange = count.valueArray();
//  println(count);
}
 
}

