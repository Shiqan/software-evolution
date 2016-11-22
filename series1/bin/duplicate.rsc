@contributor{Ferron Saan - 10386831}

module duplicate

import Set;
import List;
import IO;
import Map;
import util::Math;

import common;
import \loc;

/**
 * Find duplicate lines in a project and return % of duplication.
 */
public int findDuplicateCode(loc location, int lineblock=6) {	
	list[loc] allFiles = getFiles(project);
	
	map[list[str], int] x = ();
	map[list[str], list[loc]] y = ();
		
	for(f <- allFiles) {
		list[str] _lines = [];	 	
	 	for(l <- getLines(f)) {
	 		_lines += l;
	 		if (size(_lines) >= lineblock) {
	 			if (_lines in x) {
	 				x[_lines] += 1; 
	 				y[_lines] += [f];
	 			} else {
	 				x[_lines] = 1;
	 				y[_lines] = [f];
	 			}
	 			_lines = drop(1, _lines);
	 		}
	 	}
	}
	
	debugger("\n\n");
	
	k = getOneFrom(x);
	debugger("Random key: <k>");
	debugger("Value of key (x): <x[k]>");
	debugger("Value of key (y): <y[k]>");
	
	num total = size(x);
	num dup = sum([x[l] | l <- x]) - size(x);
	debugger("Unique blocks <total>");	
	debugger("Duplicate blocks <dup>");	
	
	int m = max([x[l] | l <- x]);
	map[int, set[list[str]]] invert_x = invert(x);
	debugger("Most used line: <invert_x[m]>, <m> times.");	
	
 
 	total_loc = getLocProject(location);
 	
 	int dup_perc = percent(dup*lineblock, total_loc);
 	debugger("Percentage of duplicate lines: <dup_perc>");
 
	return dup_perc;
}