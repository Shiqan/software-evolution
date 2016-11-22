@contributor{Ferron Saan - 10386831}

module duplicate

import Set;
import List;
import IO;
import Map;
import util::Math;

import common;
import \loc;

@doc{Find duplicate lineblocks in a project and return map with occurences}
public map[list[str], list[loc]] findDuplicateCode(loc location, int lineblock=6) {	
	list[loc] allFiles = getFiles(project);
	
	map[list[str], list[loc]] result = ();
		
	for(f <- allFiles) {
		list[str] _lines = [];	 	
	 	for(l <- getLines(f)) {
	 		_lines += l;
	 		if (size(_lines) >= lineblock) {
	 			if (_lines in result) {
	 				result[_lines] += [f];
	 			} else {
	 				result[_lines] = [f];
	 			}
	 			_lines = drop(1, _lines);
	 		}
	 	}
	}
	
	
	k = getOneFrom(result);
	debugger("Random key: <k>");
	debugger("Value of key (result): <result[k]>");
		
	num total = size(result);
	num dup = sum([size(result[l]) | l <- result]) - size(result);
	debugger("Unique blocks <total>");	
	debugger("Duplicate blocks <dup>");	
	
	int m = max([size(result[l]) | l <- result]);
	for (l <- result) {
		if (m == size(result[l])) {
			debugger("Most used line: <l>, <m> times.");	
		}
	}
	 
	return result;
}