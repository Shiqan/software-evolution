@contributor{Ferron Saan - 10386831}

module duplicate

import Set;
import List;
import IO;
import Map;

import common;

@doc{Find duplicate lineblocks in a project and return map with occurences}
public list[list[tuple[str line, int linenumber, loc file]]] findDuplicateCode(loc location) {	
	list[loc] allFiles = getFiles(location);
	
	list[list[tuple[str line, int linenumber, loc file]]] endresult = [];
	
	for(f <- allFiles) {
		list[tuple[str line, int linenumber, loc file]] result = [];
		
	 	for(l <- getLines(f)) {
	 		result += [<l.line, l.linenumber, f>];
	 	}
	 	
	 	endresult += [result];
	}
	 
	return endresult;
}