@contributor{Ferron Saan - 10386831}

module duplicate

import Set;
import List;
import IO;
import Map;

import common;

/**
 * Find duplicate lines in a project.
 */
public int findDuplicateCode(loc location) {	
	list[loc] allFiles = getFiles(project);
	
	map[str, int] x = ("placeholder": 0);
		
	for(f <- allFiles) {	 	
	 	for(l <- getLines(f)) {
	 		if (l in x) x[l] += 1; else x[l] = 1;
	 	}
	}
	
	debugger("\tUnique lines <size(x)>");	
	debugger("\tDuplicate lines <sum([x[l] | l <- x]) - size(x)>");	
	
	int m = max([x[l] | l <- x]);
	y = invert(x);
	debugger("\tMost used line<y[m]>, <m> times.");	
	
	// instead of 1 line, n lines
	// instead of str a list[str]?
	// 
	
	return 0;
}