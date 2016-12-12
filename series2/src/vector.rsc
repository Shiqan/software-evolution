@contributor{Ferron Saan - 10386831}

module vector

import IO;
import String;
import Map;
import List;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::csv::IO;

import common;
import metrics;

public list[tuple[loc method, list[int] vector]] get_vectors() {
	model = createM3FromEclipseProject(testproject);
	list[tuple[loc method, list[int] vector]] vectors = [];
	// vector [lines, loc, comments, params, variables, cc]
	
	int i = 1, total = size(methods(model));
	for (method <- methods(model)) {
		print("Method file <i> of <total>\r");
		
		lines = getLines(method);
		lines2 = filterLines(lines);
		
		if (lines == []) continue;
		if (lines2 == []) continue;
				
		v = [];
		v += [size(lines)];
		v += [size(lines2)];
		v += [size(lines) - size(lines2)];
		v += [params(lines2[0].line)];
		v += [variables(lines2)];
		v += [cyclomaticComplexity(lines2)];
		
		vectors += [<method, v>];
		
		i += 1;
	}	
	
	return vectors;
}

public void write_vectors() {
	list[tuple[loc method, list[int] vector]]vectors = get_vectors();
	writeCSV(vectors, file_vectors);
}