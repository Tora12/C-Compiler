/**
 * @file treeNode.hh
 * @author Jenner Higgins
 * @brief 
 * @version 0.3
 * @date 2022-09-18
 * 
 * @copyright Copyright (c) 2022
 * 
 */
#ifndef TREENODE_HH
#define TREENODE_HH

static const int MAXCHILDEREN = 3;

/**
 * @brief 
 * 
 */
typedef struct treeNode {
    // connectivity in the tree
    struct treeNode *child[MAXCHILDEREN];       // childeren of the node
    struct treeNode *sibling;                   // siblings for the node

    // the kind of node
    int lineno;                                 // line number relevant to this node
    NodeKind nodekind;                          // type of this node
    union                                       // subtype of type
    {
        DeclKind decl;
        StmtKind stmt;
        ExpKind exp;
    } subkind;

    // extra prperties about the node depending on type of the node
    union
    {
        OpKind op;                              // type of token (same as in bison)
        int value;                              // used when an integer constant or boolean
        unsigned char cvalue;                   // used when a character
        char *string;                           // used when a string constant
        char *name;                             // used when IdK
    } attr;

    ExpType expType;                            // used when ExpK for type checking
    bool isArray;                               // is this an array
    bool isStatic;                              // is staticly allocated?
    
    // even more semantic stuff will go here in later assignments
} TreeNode;

// Kinds of Operators
// these are the token numbers for the operators same as in flex
typedef int OpKind;

// Kinds of Statements
//typedef enum {DeclK, StmtK, ExpK} NodeKind;
enum NodeKind { DeclK, StmtK, ExpK };

// Subkinds of Declarations
enum DeclKind { VarK, FuncK, ParamK};

// Subkinds of Statements
enum StmtKind { NullK, IfK, WhileK, ForK, CompoundK, ReturnK, BreakK, RangeK };

// Subkinds of Expressions
enum ExpKind { OpK, ConstantK, IdK, AssignK, InitK, CallK };

// ExpType is used for type checking (Void means no type or value, UndefinedType means undefined
enum ExpType { Void, Integer, Boolean, Char, CharInt, Equal, UndefinedType };

// What kind of scoping is used? (decided during typing)
enum VarKind { None, Local, Global, Parameter, LocalStatic };

#endif