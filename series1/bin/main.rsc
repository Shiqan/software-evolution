@contributor{Ferron Saan - 10386831}

module main

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import DateTime;

import common;
import \loc;
import cc;
import duplicate;
import scores;
import testcoverage;

public void main() {

	datetime start_time = now();
	debugger("Start analyzing at: <start_time>");
	
	analyzeProject(project);
	//analyzeProject(project2);
	
	datetime end_time = now();
	debugger("Finished analyzing at: <end_time>");
}	

@doc{Something here}
public void analyzeProject(loc location){
	
	str risk1 = riskUnitSize(location);
	str risk2 = riskLOC(location);
	str risk3 = riskDuplication(location);
	str risk4 = riskCC(location);
	str risk5 = riskCoverage(location);
	
	println("Scores for project <location>:");
	println("--- Unit Size: <risk1>");
	println("--- LOC: <risk2>");
	println("--- Duplication: <risk3>");
	println("--- Complexity: <risk4>");
	println("--- Test Coverage: <risk5>");
}