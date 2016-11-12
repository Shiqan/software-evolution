@contributor{Ferron Saan - 10386831}

module main

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;

import common;
import \loc;
import cc;
import duplicate;

public void main(){
	
	//model = createM3FromEclipseProject(project);
 //     
 //   getAvgLocMethod(model);
 //   getAvgLocFile(project);
 //   getAvgLocClass(model);
 
 	findDuplicateCode(project);
 	
}