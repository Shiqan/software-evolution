@contributor{Ferron Saan - 10386831}

module testcoverage

import IO;
import String;
import List;
import util::FileSystem;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::\syntax::Java15;
import ParseTree;
import util::Math;

import common;

/* 
 * Currently I just get the number of methods in test file and 
 * calculate the percentage of total methods in the project. 
 * Getting the methods in test files is questionable already because I only check for
 * junit or test in the name... But even if this was the perfect way to get the
 * numbers of methods in test files this metric does not make much sense. 
 * E.g. a test method can cover multiple methods etc etc.
 *
 * A much better way is to check the ease of which a test can be written,
 * such as looking if all variables declared in a file or class 
 * are used within that file or class. 
 * This is also proposed (along with other metrics for testability)
 * by Bruntik and van Deursen (2004). 
 * 
 * Bruntink, M., & Van Deursen, A. (2004, September). Predicting class testability using object-oriented metrics. In Source Code Analysis and Manipulation, 2004. Fourth IEEE International Workshop on (pp. 136-145). IEEE.
 */

public int getTestCoverage(loc location) {

	int testmethods = sum([size(getMethods(f)) | f <- getTestFiles(location)]);
	int totalmethods = sum([size(getMethods(f)) | f <- getFiles(location)]);
	int coverage = percent(testmethods, totalmethods);
	
	debugger("Test methods coverage: <coverage>%");
	
	return coverage;
}

@doc{Get all test files of a project}
public list[loc] getTestFiles(loc project, str ext="java") {
	debugger("Getting all test files of <project> with extension <ext>");
	
	// Only java files and not the test files
	list[loc] result = [f | /file(f) <- crawl(project), f.extension == ext, /junit/ := f.path || /test/ := f.path];
	//debugger(result);	
	debugger(size(result));	
	return result;
}

set[MethodDec] allMethods(loc file) = {m | /MethodDec m := parse(#start[CompilationUnit], file)};
list[loc method] getMethods(loc file) = [m@\loc | m <- allMethods(file)];