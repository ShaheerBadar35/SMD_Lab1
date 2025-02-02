import 'dart:io';

void main() {
  Solution obj = Solution();
  obj.analyzeFile();
  obj.calculateLineWithHighestFrequency();
  obj.printHighestWordFrequencyAcrossLines();
  obj.printLineNumbersWithHighestFrequency();
}

class Solution {
  List<String> lines = [];
  List<List<String>> highestWordsPerLine = [];
  List<int> highestFrequencyPerLine = [];
  int globalHighestFrequency = 0;
  List<int> linesWithGlobalHighest = [];

  void analyzeFile() {
    File file = File('file.txt');

    if (!file.existsSync()) {
      print(
          "Error: file.txt not found in the current working directory: ${Directory.current.path}");
      return;
    }

    lines = file.readAsLinesSync();

    for (String line in lines) {
      Map<String, int> wordCounts = {};

      List<String> words = line
          .split(RegExp(r'[\s,!.?:;]+'))
          .where((w) => w.isNotEmpty)
          .toList();

      for (String word in words) {
        String normalized = word.toLowerCase();
        wordCounts[normalized] = (wordCounts[normalized] ?? 0) + 1;
      }

      int maxCount = 0;
      wordCounts.forEach((word, count) {
        if (count > maxCount) {
          maxCount = count;
        }
      });
      highestFrequencyPerLine.add(maxCount);

      List<String> maxWords = [];
      wordCounts.forEach((word, count) {
        if (count == maxCount) {
          maxWords.add(word);
        }
      });
      highestWordsPerLine.add(maxWords);
    }
  }

  void calculateLineWithHighestFrequency() {
    if (highestFrequencyPerLine.isEmpty) {
      return;
    }

    for (int freq in highestFrequencyPerLine) {
      if (freq > globalHighestFrequency) {
        globalHighestFrequency = freq;
      }
    }
    for (int i = 0; i < highestFrequencyPerLine.length; i++) {
      if (highestFrequencyPerLine[i] == globalHighestFrequency) {
        linesWithGlobalHighest.add(i + 1);
      }
    }
  }

  void printHighestWordFrequencyAcrossLines() {
    print("The following words have the highest word frequency per line:");
    for (int i = 0; i < lines.length; i++) {
      if (highestFrequencyPerLine[i] == globalHighestFrequency) {
        String wordsStr = '["${highestWordsPerLine[i].join('", "')}"]';
        print('$wordsStr (appears in line ${i + 1})');
      }
    }
  }

  void printLineNumbersWithHighestFrequency() {
    if (linesWithGlobalHighest.isEmpty) {
      print("No lines found with a highest word frequency.");
    } else {
      print(
          "\nLine number(s) with the highest word frequency ($globalHighestFrequency occurrences): ${linesWithGlobalHighest.join(', ')}");
    }
  }
}
