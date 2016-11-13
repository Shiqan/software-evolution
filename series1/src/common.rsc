@contributor{Ferron Saan - 10386831}

module common

import IO;
import String;
import List;
import util::FileSystem;

// Test file
public loc file = |project://smallsql/src/smallsql/database/Columns.java|;
public loc project = |project://smallsql/src|;

private bool debug = true;
public void debugger(value s) {
  if (debug) println(s);
}

/**
 * Get all files of a project.
 */
public list[loc] getFiles(loc project, str ext="java") {
	debugger("Getting all files of <project> with extension <ext>");
	
	// Only java files and not the test files
	list[loc] result = [f | /file(f) <- crawl(project), f.extension == ext,  /junit/ !:= f.path, /test/ !:= f.path];
	//debugger(result);	
	debugger(size(result));	
	return result;
}

/**
 * Get the lines of a file.
 * Trim the lines
 * Remove both single and multiline comments
 * Remove single bracket lines
 */
public list[str] getLines(loc location) {
	list[str] allLines = readFileLines(location);

	list[str] result = [];
	bool comment = false;

	for(s <- allLines) {    	
    	// Remove spaces
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
	   
	   // Skip empty lines
	    if (!isEmpty(s)) {
	      result += s;
	    }
  	}
  	
	//debugger("Lines in file <location>");
	//debugger(result);
	
	return result;
}
