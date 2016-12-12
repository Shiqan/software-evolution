module \test

import List;

import common;
import vector;
import metrics;
import duplication;

public loc m = |java+method:///smallsql/database/SSStatement/setFetchDirection(int)|;
public list[tuple[int, str]] l = [<1, "/**">,
								  <2, "     * If the current page is only an pointer to a larger page then the larger page is loaded else it return this.">,
								  <3, "     * @return this or the page with the valid data.">,
								  <4, "     * @throws Exception">,
								  <5, "     */">,
								  <6, "\tfinal private StoreImpl loadUpdatedStore() throws Exception{">,
								  <7, "\t\tif(status != UPDATE_POINTER) {return this;}">,
								  <8, "\t\tStoreImpl storeTemp = table.getStore( ((TableStorePage)storePage).con, filePosUpdated, type);">,
								  <9, "\t\tstoreTemp.updatePointer = this;">,
								  <10,"\t\treturn storeTemp;">,
								  <11, "    }">];

public test bool test_vector() {
	result = get_vectors();
	result = [r.vector | r <- result];
	
	assertion = [[5,4,1,1,3,1], [5,4,1,1,3,1], [5,4,1,1,3,1], [11,6,5,1,3,2], [23,16,7,1,4,6]];
	return assertion == result;
}

public test bool test_cosine() {
	result = cosine([1,2,3,4,5],[1,2,3,4,5]);
	
	real assertion = 1.;
	return assertion == result;
}

public test bool test_euclidean() {
	result = euclidean([1,2,3,4,5],[1,2,3,4,5]);
	
	real assertion = 0.;
	return assertion == result;
}

public test bool test_extractfile() {
	result = extractFile(m);
	assertion = "/smallsql/database/SSStatement";
	
	return assertion == result;
}

public test bool test_cosine_dup() {
	result = size(cosine_dup());
	assertion = 1647;
	
	return assertion == result;
}

public test bool test_metric_variable() {
	result = variables(l);
	assertion = 3;
	
	return assertion == result;
}

public test bool test_metric_params() {
	result = params(l[5][1]);
	assertion = 1;
	
	return assertion == result;
}

public test bool test_metric_cc() {
	result = cyclomaticComplexity(l);
	assertion = 2;
	
	return assertion == result;
}