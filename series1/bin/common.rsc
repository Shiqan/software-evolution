@contributor{Ferron Saan - 10386831}

module common

import IO;
import String;
import List;
import util::FileSystem;

// Test file
public loc file = |project://smallsql/src/smallsql/database/Columns.java|;
public loc project = |project://smallsql/src|;
public loc project2 = |project://hsqldb-2.3.1/hsqldb/src|;

private bool debug = true;
public void debugger(value s) {
  if (debug) println(s);
}

@doc{Get all files of a project}
public list[loc] getFiles(loc location, str ext="java") {
	debugger("Getting all files of <location> with extension <ext>");
	
	// Only java files and not the test files
	list[loc] result = [f | /file(f) <- crawl(location), f.extension == ext,  /junit/ !:= f.path, /test/ !:= f.path];
	//debugger(result);	
	debugger(size(result));	
	return result;
}

@doc{Returns string with all whitespaces removed}
public str strip(str s) {
	list[str] toStrip = [" ", "\t"];
  
	for (rm <- toStrip) {
		s = replaceAll(s, rm, "");
	}
	
	return s;
} 

@doc{Get all the code lines of a file}
public list[str] getLines(loc location) {
	list[str] allLines = readFileLines(location);

	list[str] result = [];
	bool comment = false;

	for(s <- allLines) {    	
    	// Remove leading and trailing spaces
    	s = trim(s);
    	
    	// Skip multi line comments
    	if (comment) {
    		if (/.*\*\/$/ := s) {
    			//debugger("Multi line COMMENTS" + s);
    			comment = false;
    		}
    		continue;
    	} else {
    		if (/^\/\*.*/ := s) {
    			//debugger("Multiline COMMENTS" + s);
    			comment = true;
    			continue;
    		}
    	}
    	
    	// Skip single line comments
    	if (/^\/\// := s) {
    		//debugger("Single COMMENTS" + s); 
    		continue;
    	}
	
	    // Skip lines with only brackets
	   	if (/\{|\}/ := s && size(s) == 1) continue;
	   	
	   	// Remove all whitespaces from string
	   	s = strip(s);
	   
	   // Skip empty lines
	    if (!isEmpty(s)) {
	      result += s;
	    }
  	}
  	
	//debugger("Lines in file <location>");
	//debugger(result);
	
	return result;
}
