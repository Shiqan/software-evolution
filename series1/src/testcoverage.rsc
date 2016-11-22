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

public int getTestCoverage(loc location) {

	int testmethods = sum([size(getMethods(f)) | f <- getTestFiles(location)]);
	int totalmethods = sum([size(getMethods(f)) | f <- getFiles(location)]);
	int coverage = percent(testmethods, totalmethods);
	
	debugger("Test methods coverage: <coverage>%");
	
	return coverage;
}

@doc{Get all test files of a project}
public list[loc] getTestFiles(loc project, str ext="java") {
	debugger("Getting all files of <project> with extension <ext>");
	
	// Only java files and not the test files
	list[loc] result = [f | /file(f) <- crawl(project), f.extension == ext, /junit/ := f.path || /test/ := f.path];
	//debugger(result);	
	debugger(size(result));	
	return result;
}

set[MethodDec] allMethods(loc file) = {m | /MethodDec m := parse(#start[CompilationUnit], file)};
list[loc method] getMethods(loc file) = [m@\loc | m <- allMethods(file)];