

String convertSelectedIndexesIntoReadable(Iterable<int> indexes) {

  //at first, assume that all indexes are consecutive
  //ie, first and last will be the range of the items
  String result = "";

  List<List<int>> ranges = findConsecutiveRanges(indexes.toList());

  for (int i = 0; i != ranges.length; i++) {
    var r = ranges[i];
    result = "$result ${convertIndexToTime(r.first)} - ${convertIndexToTime(r.last + 1)}";
    if (i != ranges.length - 1) {
      result = "$result,";
    }
  }

  return result;
}

String convertIndexToTime(int index) {
  if (index == 144) {
    return "0:00";
  }
  return "${index ~/ 6}:${index % 6}0";
}

List<List<int>> findConsecutiveRanges(List<int> list) {
  // a list of list<ints>, holds consecutive ranges
  // ie [[1,2,3], [7,8], [11,12,13,14], [17]]
  List<List<int>> result = [];

  // the range currently being added to
  List<int> currentRange = [list.first];

  for (int i = 1; i != list.length; i++) {
    if (list[i] - currentRange.last == 1) {
      currentRange.add(list[i]);
    } else {
      result.add(currentRange);
      currentRange = [list[i]];
    }
  }
  result.add(currentRange);

  return result;

}
