@contributor{Ferron Saan - 10386831}

module \loc

import IO;
import String;
import util::FileSystem;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import common;


public void init() {
	int lines = getLoc(file);
}
	
/**
 * Get the LOC of a file.
 */
public int getLoc(loc location) {
	list[str] lines = getLines(location);
	int n = size(lines);
	debugger("Number of lines in <location>");
	debugger(n);
	return n;
}