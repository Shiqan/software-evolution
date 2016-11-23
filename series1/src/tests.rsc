module tests

import IO;
import String;
import List;
import Map;

import common;
import cc;

public void assertGetLines() {
	result = getLines(file);
	assert 35 == size(result) : "Did not got the expected 35 lines in <file>! <result>";
}

public void assertStrip() {
	str s1 = "Hello World!";
	str s2 = " H el \t lo    Worl  \t d!  ";
	
	assert strip(s1) == strip(s2) : "Did not got the same string back from strip method!";
}

public void assertCC() {
	result = getCC(file);
	assert 12 == sum([r[0] | r <- result]) : "Did not got the expected 12 cc in <file>! <result>";
}

public void assertDuplicate() {
	map[list[str], list[loc]] result = ();
	
	list[str] _lines = [];
	for(l <- getLines(file)) {
 		_lines += l;
 		if (size(_lines) >= 6) {
 			if (_lines in result) {
 				result[_lines] += [file];
 			} else {
 				result[_lines] = [file];
 			}
 			_lines = drop(1, _lines);
 		}
 	}
 	
 	k = getOneFrom(result);
 	assert 6 == size(k) : "Did not get the expected 6 lines in a lineblock";
 	debugger("Random key: <k>");
	debugger("Value of key (result): <result[k]>");
}