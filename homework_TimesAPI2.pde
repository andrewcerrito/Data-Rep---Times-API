// 9EC3E16CEB0B89825E5E3457A5B5FC24:2:68364079
// API request tool: http://prototype.nytimes.com/gst/apitool/index.html

// What I have: two IntDicts with date ranges and counts for cellphone and payphone,
// and a String array with the combined sorted date range.
// What I need to do: Plot the data points onto this combined date range.
import blprnt.nytimes.*;
import java.util.Collections;

// Insert the terms you want to search for here!
 String search1 = "cassette";
 String search2 = "CD";
// If you want to use a multi-word term, you have to use this syntax:
// String search1 = "\"pay phone\"";
// String search2 = "cellphone";


String apiKey = "9EC3E16CEB0B89825E5E3457A5B5FC24:2:68364079";
ArrayList<String> combinedDates = new ArrayList();
String[] sortedDates;

Phone payphone = new Phone();
Phone cellphone = new Phone();

PFont font;
PFont smallerFont;

color color1 = color(255, 0, 0);
color color2 = color(82, 83, 255);
int maxValue;

void setup() {
  size(1280, 720, P3D);
  smooth(3);
  background(0);
  font = createFont("Futura Medium", 16);
  smallerFont = createFont("Futura Medium", 12);
  textFont(font);

  TimesEngine.init(this, apiKey);

  // combine the years available for each dataset into one date range
  payphone.getPubYears(search1, "publication_year");
  cellphone.getPubYears(search2, "publication_year");
  combineArrays(payphone.dateRange, cellphone.dateRange);

  // get the maximum occurence rate for both datasets
  maxValue = getMaxValue(payphone, cellphone);

  // DEBUG - don't need this anymore
  // debug(cellphone);
}


void draw() {
  background(0);

  fill(255);
  text("NYT Dateline Comparisons", 10, 20);
  text("See a comparison of any two terms mentioned by year in the New York Times.", 10, 40);
  fill(color1);
  rect(10, 60, 20, 20);
  fill(color2);
  rect(10, 90, 20, 20);
  fill(255);
  text(search1, 45, 75);
  text(search2, 45, 105);

  graphData(payphone, cellphone, color1, color2);
  //  graphData(cellphone, color2);
  //  graphData(payphone, color1);
}


// date range combination function
void combineArrays (String[] arrayOne, String[] arrayTwo) {
  for (int i = 0; i < arrayOne.length; i++) {
    combinedDates.add(arrayOne[i]);
  }
  for (int i = 0; i < arrayTwo.length; i++) {
    if (combinedDates.contains(arrayTwo[i]) == false) {
      combinedDates.add(arrayTwo[i]);
    }
  }
  //auto-sorts arraylist contents
  Collections.sort(combinedDates);
  // ecxport contents of ArrayList to String array
  sortedDates = combinedDates.toArray(new String[combinedDates.size()]);
  // println(sortedDates);
}



// finds the maximum amount of occurrences per year for each dataset for mapping purposes later
int getMaxValue (Phone dataset1, Phone dataset2) {
  int max1 = max(dataset1.valueRange);
  int max2 = max(dataset2.valueRange);
  int combinedMax = max(max1, max2);
  // println(combinedMax);
  return(combinedMax);
}

// graphing function
void graphData(Phone dataset1, Phone dataset2, color c1, color c2) {
  int barWidth = (width/sortedDates.length);
  int graphLine = (3*height/4);
  int leftBorder = 25;
  stroke(255);
  line (0, graphLine, width, graphLine);

  // write the date range equally spaced across the length of the screen
  for (int i = 0; i < sortedDates.length; i++) {
    pushMatrix();
    int currentBarLoc = leftBorder + i*barWidth;
    translate(currentBarLoc, graphLine+10);
    rotate(radians(90));
    fill(255);
    text(sortedDates[i], 0, 0);
    popMatrix();

    // graph the first dataset and label it numerically
    for (int j = 0; j < dataset1.dateRange.length; j++) {
      if (sortedDates[i].equals(dataset1.dateRange[j])) {
        fill(c1);
        noStroke();
        int mappedValue = (int) map(dataset1.valueRange[j], 0, maxValue, 0, graphLine-100);
        rect(currentBarLoc, graphLine, barWidth/4, -mappedValue);
       // a lot of code that only displays the count above the bar!!
        pushMatrix();
        pushStyle();
        textFont(smallerFont);
        textAlign(CENTER, CENTER);
        //fill(255);
        translate(currentBarLoc + barWidth/8 + 2, graphLine-mappedValue-25);
        rotate(radians(90));
        text(dataset1.valueRange[j], 0, 0);
        popMatrix();
        popStyle();
      }
    }

    //graph the second dataset right next to it
    for (int k = 0; k < dataset2.dateRange.length; k++) {
      if (sortedDates[i].equals(dataset2.dateRange[k])) {
        fill(c2);
        noStroke();
        int mappedValue = (int) map(dataset2.valueRange[k], 0, maxValue, 0, graphLine-100);
        rect(currentBarLoc + barWidth/4, graphLine, barWidth/4, -mappedValue);
        // again, display count above bar
        pushMatrix();
        pushStyle();
        textFont(smallerFont);
        textAlign(CENTER, CENTER);
        //fill(255);
        translate(currentBarLoc + 3*(barWidth/8) + 3, graphLine-mappedValue-25);
        rotate(radians(90));
        text(dataset2.valueRange[k], 0, 0);
        popMatrix();
        popStyle();
      }
    }
  }
}

// older, worse graphing function - only graphs one function
// and wouldn't put the graph bars next to each other if used
//void graphData(Phone phonetype, color c) {
//  int barWidth = (width/sortedDates.length);
//  int graphLine = (3*height/4);
//  int leftBorder = 25;
//  stroke(255);
//
//  line (0, graphLine, width, graphLine);
//
//  for (int i = 0; i < sortedDates.length; i++) {
//    pushMatrix();
//    int currentBarLoc = leftBorder + i*barWidth;
//    translate(currentBarLoc, graphLine+10);
//    rotate(radians(90));
//    fill(255);
//    text(sortedDates[i], 0, 0);
//    popMatrix();
//
//    for (int j = 0; j < phonetype.dateRange.length; j++) {
//      if (sortedDates[i].equals(phonetype.dateRange[j])) {
//        fill(c);
//        noStroke();
//        int mappedValue = (int) map(phonetype.valueRange[j], 0, maxValue, 0, graphLine-100);
//        rect(currentBarLoc, graphLine, barWidth/2, -mappedValue);
//        // println(sortedDates[i] + ":          " + phonetype.valueRange[j]);
//      }
//    }
//  }
//}

// a lovely debugging function just for me - show the amount of data hits per year for a term
void debug (Phone phonetype) {
  for (int i = 0; i < phonetype.dateRange.length; i++) {
    println(phonetype.dateRange[i] + " , " + phonetype.valueRange[i]);
  }
}

