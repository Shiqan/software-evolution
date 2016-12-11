@contributor{Ferron Saan - 10386831}

module metrics

import IO;
import String;
import List;

import common;

public int cyclomaticComplexity(list[tuple[int linenumber, str line]] lines) {
	result = 0;	
	
	for (l <- lines) {
		result += size(findAll(l.line, "{"));
	}

 	return result;
}

public int params(str line) {
	result = 1;	
	
	result += size(findAll(line, ","));

 	return result;
}

public int variables(list[tuple[int linenumber, str line]] lines) {
	result = 0;	
	
	for (l <- lines) {
		if (startsWith(l.line, "for") || startsWith(l.line, "if") || startsWith(l.line, "while") || startsWith(l.line, "return")) continue;
		result += size(findAll(l.line, "="));
	}

 	return result;
}