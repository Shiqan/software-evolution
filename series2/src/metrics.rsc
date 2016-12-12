@contributor{Ferron Saan - 10386831}

module metrics

import IO;
import String;
import List;
import util::Math;

import common;

public real cosine(list[int] a, list[int] b) {
	int numerator = sum([i.first * i.second | i <- zip(a,b)]);	
	real denominator = sqrt(sum([ai*ai | ai <- a])*sum([bi*bi | bi <- b]));
	real result = numerator / denominator;	
	
	//debugger(result);
	return result;
}

public real euclidean(list[int] a, list[int] b) {
	real result = sqrt(sum([pow((i.first - i.second), 2) | i <- zip(a,b)]));
	
	//debugger(result);
	return result;	
}


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