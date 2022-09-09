#ifndef SCANTYPE_H
#define SCANTYPE_H
// 
//  SCANNER TOKENDATA
// 
struct TokenData {
	int tokenclass; 	// token class
	int linenum;		// line where found
	char *tokenstr;	// raw string
	char cvalue;		// any character value
	int nvalue;			// any numeric or boolean value
	char *svalue;		// any string value (e.g. an ID)
	int slen;
};

#endif