/**
 * @file scanType.hh
 * @brief Contains the sturct TokenData Type
 * @date 2022-09-09
 * 
 */
#ifndef SCANTYPE_H
#define SCANTYPE_H
/**
 * @struct TokenData
 * @brief Creates a pass-back data space between flex and bison
 * 
 */
struct TokenData {
	int tokenclass; 	///< token class
	int linenum;		///< line number where found
	char *tokenstr;		///< raw string
	char cvalue;		///< any single character value
	int nvalue;			///< any numeric or boolean value
	char *svalue;		///< any string value (e.g. an ID)
	int slen;			///< string length
};

#endif