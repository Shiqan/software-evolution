@contributor{Ferron Saan - 10386831}

module main

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;

import common;
import \loc;
import cc;
import duplicate;
import scores;
import testcoverage;

public void main() {
	//analyzeProject(project);
	//analyzeProject(project2);
	//riskUnitSize(project);
	riskCC(project);
}	

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